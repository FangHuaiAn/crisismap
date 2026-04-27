package com.crisismap.app.ui.map

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.crisismap.app.domain.regions.RegionIntelligenceSummary
import com.crisismap.app.ui.regions.displayName

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RegionMarkerSheet(
    summary: RegionIntelligenceSummary,
    onDismiss: () -> Unit
) {
    ModalBottomSheet(onDismissRequest = onDismiss) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = summary.region.displayName,
                style = MaterialTheme.typography.headlineSmall
            )
            Text(
                text = "${summary.newsClusterCount} news | ${summary.researchArticleCount} research",
                style = MaterialTheme.typography.bodyMedium
            )

            if (summary.topNewsClusters.isNotEmpty()) {
                Text("News", style = MaterialTheme.typography.titleMedium)
                summary.topNewsClusters.forEach { cluster ->
                    ListItem(
                        headlineContent = { Text(cluster.title) },
                        supportingContent = { Text("${cluster.eventCount} items | ${cluster.sourceCount} sources") }
                    )
                    HorizontalDivider()
                }
            }

            if (summary.recentResearchArticles.isNotEmpty()) {
                Text("Research", style = MaterialTheme.typography.titleMedium)
                summary.recentResearchArticles.forEach { article ->
                    ListItem(
                        headlineContent = { Text(article.title) },
                        supportingContent = { Text("${article.thinkTank} | ${article.date}") }
                    )
                    HorizontalDivider()
                }
            }
        }
    }
}
