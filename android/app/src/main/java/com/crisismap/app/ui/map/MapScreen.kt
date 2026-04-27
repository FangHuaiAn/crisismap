package com.crisismap.app.ui.map

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AssistChip
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.crisismap.app.data.model.Region
import com.crisismap.app.domain.regions.RegionIntelligenceSummary
import com.crisismap.app.ui.regions.displayName

@Composable
fun MapScreen(
    modifier: Modifier = Modifier,
    viewModel: MapViewModel = viewModel()
) {
    val state = viewModel.uiState
    var selectedSummary by remember { mutableStateOf<RegionIntelligenceSummary?>(null) }

    Box(modifier = modifier.fillMaxSize()) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0xFF101418))
        ) {
            Text(
                text = "Map",
                color = Color.White,
                style = MaterialTheme.typography.headlineSmall,
                modifier = Modifier
                    .align(Alignment.TopStart)
                    .padding(16.dp)
            )

            state.summaries.forEach { summary ->
                RegionMarker(
                    summary = summary,
                    modifier = Modifier.align(summary.region.mapAlignment),
                    onClick = { selectedSummary = summary }
                )
            }

            if (state.isLoading) {
                LinearProgressIndicator(
                    modifier = Modifier
                        .align(Alignment.TopCenter)
                        .padding(top = 64.dp)
                )
            }
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
private fun BoxScope.RegionMarker(
    summary: RegionIntelligenceSummary,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    val markerSize = 46.dp + (summary.heatScore * 22).dp

    Surface(
        onClick = onClick,
        modifier = modifier
            .offset { summary.region.mapOffset }
            .clip(RoundedCornerShape(8.dp)),
        color = Color(0xFFE6EDF3),
        contentColor = Color(0xFF101418),
        tonalElevation = 4.dp
    ) {
        Column(
            modifier = Modifier.padding(horizontal = 10.dp, vertical = 8.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Surface(
                modifier = Modifier.clip(CircleShape),
                color = Color(0xFF2F81F7),
                contentColor = Color.White
            ) {
                Box(
                    modifier = Modifier
                        .padding(4.dp)
                        .clip(CircleShape)
                        .background(Color(0xFF2F81F7))
                        .padding(markerSize / 8),
                    contentAlignment = Alignment.Center
                ) {
                    Text(summary.totalCount.toString(), style = MaterialTheme.typography.labelMedium)
                }
            }
            Text(summary.region.displayName, style = MaterialTheme.typography.labelMedium)
            AssistChip(
                onClick = onClick,
                label = { Text("${summary.newsClusterCount}/${summary.researchArticleCount}") }
            )
        }
    }
}

private val Region.mapAlignment: Alignment
    get() = when (this) {
        Region.MiddleEast -> Alignment.Center
        Region.Europe -> Alignment.TopCenter
        Region.EastAsia -> Alignment.CenterEnd
        Region.Africa -> Alignment.BottomCenter
        Region.Americas -> Alignment.CenterStart
        Region.All -> Alignment.Center
    }

private val Region.mapOffset: IntOffset
    get() = when (this) {
        Region.MiddleEast -> IntOffset(20, 0)
        Region.Europe -> IntOffset(0, 72)
        Region.EastAsia -> IntOffset(-42, 0)
        Region.Africa -> IntOffset(0, -104)
        Region.Americas -> IntOffset(42, 0)
        Region.All -> IntOffset.Zero
    }
