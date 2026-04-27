@file:Suppress("DEPRECATION")

package com.crisismap.app.ui.map

import android.os.Bundle
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.Alignment
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.ui.unit.dp
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.viewmodel.compose.viewModel
import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.Region
import com.crisismap.app.domain.regions.RegionIntelligenceSummary
import org.maplibre.android.MapLibre
import org.maplibre.android.annotations.MarkerOptions
import org.maplibre.android.camera.CameraPosition
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.maps.MapView

@Composable
fun MapScreen(
    modifier: Modifier = Modifier,
    viewModel: MapViewModel = viewModel()
) {
    val state = viewModel.uiState
    var selectedEvent by remember { mutableStateOf<CrisisEvent?>(null) }
    var selectedSummary by remember { mutableStateOf<RegionIntelligenceSummary?>(null) }

    Box(modifier = modifier.fillMaxSize()) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0xFF101418))
        ) {
            MapLibreMapBackground(
                eventMarkers = state.eventMarkers,
                summaries = state.summaries,
                onEventMarkerClick = { marker ->
                    selectedSummary = null
                    selectedEvent = state.events.firstOrNull { it.id == marker.eventId }
                },
                onRegionMarkerClick = {
                    selectedEvent = null
                    selectedSummary = it
                },
                modifier = Modifier.fillMaxSize()
            )

            Text(
                text = "Map",
                color = Color.White,
                style = MaterialTheme.typography.headlineSmall,
                modifier = Modifier
                    .align(Alignment.TopStart)
                    .padding(16.dp)
            )

            if (state.isLoading) {
                LinearProgressIndicator(
                    modifier = Modifier
                        .align(Alignment.TopCenter)
                        .padding(top = 64.dp)
                )
            }
        }

        selectedEvent?.let { event ->
            EventMarkerSheet(
                event = event,
                onDismiss = { selectedEvent = null }
            )
        }

        selectedSummary?.let { summary ->
            RegionMarkerSheet(
                summary = summary,
                onDismiss = { selectedSummary = null }
            )
        }
    }
}

@Composable
private fun MapLibreMapBackground(
    eventMarkers: List<EventMapMarker>,
    summaries: List<RegionIntelligenceSummary>,
    onEventMarkerClick: (EventMapMarker) -> Unit,
    onRegionMarkerClick: (RegionIntelligenceSummary) -> Unit,
    modifier: Modifier = Modifier
) {
    val mapView = rememberMapViewWithLifecycle()
    val currentOnEventMarkerClick by rememberUpdatedState(onEventMarkerClick)
    val currentOnRegionMarkerClick by rememberUpdatedState(onRegionMarkerClick)
    var isConfigured by remember { mutableStateOf(false) }
    var mapLibreMap by remember { mutableStateOf<MapLibreMap?>(null) }

    AndroidView(
        modifier = modifier,
        factory = { mapView },
        update = { view ->
            if (!isConfigured) {
                view.getMapAsync { map ->
                    configureMapLibreMap(map) {
                        mapLibreMap = map
                    }
                    isConfigured = true
                }
            }
        }
    )

    DisposableEffect(mapLibreMap, eventMarkers, summaries) {
        val map = mapLibreMap ?: return@DisposableEffect onDispose {}
        val regionMarkers = buildRegionMapMarkers(summaries)
        val eventMarkersById = eventMarkers.associateBy { it.eventId }
        val summariesByRegion = summaries.associateBy { it.region }
        val eventAnnotationIds = mutableMapOf<Long, String>()
        val regionAnnotationIds = mutableMapOf<Long, Region>()

        map.clear()
        eventMarkers.forEach { marker ->
            val annotation = map.addMarker(
                MarkerOptions()
                    .position(LatLng(marker.lat, marker.lng))
                    .title(marker.title)
                    .snippet(marker.snippet)
            )
            eventAnnotationIds[annotation.id] = marker.eventId
        }

        regionMarkers.forEach { marker ->
            val annotation = map.addMarker(
                MarkerOptions()
                    .position(LatLng(marker.lat, marker.lng))
                    .title(marker.title)
                    .snippet(marker.snippet)
            )
            regionAnnotationIds[annotation.id] = marker.region
        }

        map.setOnMarkerClickListener(
            MapLibreMap.OnMarkerClickListener { marker ->
                val eventMarker = eventAnnotationIds[marker.id]?.let(eventMarkersById::get)
                if (eventMarker != null) {
                    currentOnEventMarkerClick(eventMarker)
                    return@OnMarkerClickListener true
                }

                val summary = regionAnnotationIds[marker.id]?.let(summariesByRegion::get)
                    ?: return@OnMarkerClickListener false
                currentOnRegionMarkerClick(summary)
                true
            }
        )

        onDispose {
            map.setOnMarkerClickListener(null)
            map.clear()
        }
    }
}

@Composable
private fun rememberMapViewWithLifecycle(): MapView {
    val context = LocalContext.current
    val lifecycle = LocalLifecycleOwner.current.lifecycle
    val mapView = remember {
        MapLibre.getInstance(context.applicationContext)
        MapView(context).apply {
            onCreate(Bundle())
        }
    }

    DisposableEffect(lifecycle, mapView) {
        if (lifecycle.currentState.isAtLeast(Lifecycle.State.STARTED)) {
            mapView.onStart()
        }
        if (lifecycle.currentState.isAtLeast(Lifecycle.State.RESUMED)) {
            mapView.onResume()
        }

        val observer = LifecycleEventObserver { _, event ->
            when (event) {
                Lifecycle.Event.ON_START -> mapView.onStart()
                Lifecycle.Event.ON_RESUME -> mapView.onResume()
                Lifecycle.Event.ON_PAUSE -> mapView.onPause()
                Lifecycle.Event.ON_STOP -> mapView.onStop()
                Lifecycle.Event.ON_DESTROY -> mapView.onDestroy()
                else -> Unit
            }
        }
        lifecycle.addObserver(observer)

        onDispose {
            lifecycle.removeObserver(observer)
            if (!mapView.isDestroyed) {
                mapView.onPause()
                mapView.onStop()
                mapView.onDestroy()
            }
        }
    }

    return mapView
}

private fun configureMapLibreMap(map: MapLibreMap, onStyleLoaded: () -> Unit) {
    map.cameraPosition = CameraPosition.Builder()
        .target(LatLng(18.0, 18.0))
        .zoom(0.75)
        .build()
    map.uiSettings.setCompassEnabled(false)
    map.uiSettings.setLogoEnabled(false)
    map.uiSettings.setAttributionEnabled(true)
    map.uiSettings.setAttributionMargins(16, 16, 16, 180)
    map.setStyle(MapLibreMapConfig.styleUri) {
        onStyleLoaded()
    }
}
