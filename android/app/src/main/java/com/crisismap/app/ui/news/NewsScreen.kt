package com.crisismap.app.ui.news

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.AssistChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.crisismap.app.R
import com.crisismap.app.data.model.NewsSourceKind
import com.crisismap.app.domain.regions.NewsClusterSummary
import com.crisismap.app.ui.regions.displayName

@Composable
fun NewsScreen(
    modifier: Modifier = Modifier,
    viewModel: NewsViewModel = viewModel()
) {
    val state = viewModel.uiState

    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        item {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    text = stringResource(R.string.news_title),
                    style = MaterialTheme.typography.headlineSmall
                )

                if (state.isLoading) {
                    LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
                }

                state.error?.let { error ->
                    Text(
                        text = error,
                        color = MaterialTheme.colorScheme.error,
                        style = MaterialTheme.typography.bodyMedium
                    )
                    TextButton(onClick = viewModel::refresh) {
                        Text(stringResource(R.string.news_retry))
                    }
                }
            }
        }

        items(state.clusters) { cluster ->
            ListItem(
                headlineContent = { Text(cluster.title) },
                supportingContent = {
                    val sourceSummary = sourceSummaryText(cluster)
                    val baseSummary = "${cluster.region.displayName} | ${cluster.eventCount} items | ${
                        stringResource(R.string.news_source_count, cluster.sourceCount)
                    }"
                    Text(
                        listOfNotNull(baseSummary, sourceSummary)
                            .joinToString(separator = "\n")
                    )
                },
                trailingContent = {
                    AssistChip(
                        onClick = {},
                        label = { Text(String.format("%.1f", cluster.score)) }
                    )
                }
            )
            HorizontalDivider()
        }
    }
}

@Composable
private fun sourceSummaryText(cluster: NewsClusterSummary): String? {
    val direct = stringResource(R.string.news_source_direct)
    val derived = stringResource(R.string.news_source_derived)

    if (cluster.directSourceCount > 0 && cluster.derivedSourceCount > 0) {
        return listOf(
            stringResource(R.string.news_source_counted, cluster.directSourceCount, direct),
            stringResource(R.string.news_source_counted, cluster.derivedSourceCount, derived)
        ).joinToString(separator = " · ")
    }

    return cluster.sourceKinds
        .map { sourceKindText(it) }
        .takeIf { it.isNotEmpty() }
        ?.joinToString(separator = " · ")
}

@Composable
private fun sourceKindText(kind: NewsSourceKind): String =
    when (kind) {
        NewsSourceKind.Wire -> stringResource(R.string.news_source_wire)
        NewsSourceKind.Publisher -> stringResource(R.string.news_source_publisher)
        NewsSourceKind.Aggregator -> stringResource(R.string.news_source_aggregator)
        NewsSourceKind.Social -> stringResource(R.string.news_source_social)
    }
