package com.crisismap.app.ui.map

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.ThreatLevel

data class EventMapMarker(
    val eventId: String,
    val title: String,
    val snippet: String,
    val lat: Double,
    val lng: Double,
    val threatLevel: ThreatLevel
)

fun buildEventMapMarkers(events: List<CrisisEvent>): List<EventMapMarker> =
    events.mapNotNull { event ->
        val location = event.location ?: return@mapNotNull null
        EventMapMarker(
            eventId = event.id,
            title = event.title,
            snippet = location.name,
            lat = location.lat,
            lng = location.lng,
            threatLevel = event.level
        )
    }
