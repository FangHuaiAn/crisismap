package com.crisismap.app.ui.research

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
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
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable
fun ResearchScreen(
    modifier: Modifier = Modifier,
    viewModel: ResearchViewModel = viewModel()
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
                    text = "Research",
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
                        Text("Retry")
                    }
                }
            }
        }

        items(state.rows) { row ->
            ListItem(
                headlineContent = { Text(row.title) },
                trailingContent = {
                    AssistChip(
                        onClick = {},
                        label = { Text(row.count.toString()) }
                    )
                }
            )
            HorizontalDivider()
        }

        if (state.articles.isNotEmpty()) {
            item {
                Text(
                    text = "Recent",
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.padding(top = 8.dp)
                )
            }

            items(state.articles.take(8)) { article ->
                ListItem(
                    headlineContent = { Text(article.title) },
                    supportingContent = {
                        Text("${article.thinkTank} | ${article.date}")
                    }
                )
                HorizontalDivider()
            }
        }
    }
}
