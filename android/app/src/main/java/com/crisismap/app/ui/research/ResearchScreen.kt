package com.crisismap.app.ui.research

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Info
import androidx.compose.material3.AssistChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.crisismap.app.R
import com.crisismap.app.ui.shared.SourceTransparencySheet

@Composable
fun ResearchScreen(
    modifier: Modifier = Modifier,
    viewModel: ResearchViewModel = viewModel()
) {
    val state = viewModel.uiState
    var showSourceTransparency by rememberSaveable { mutableStateOf(false) }

    if (showSourceTransparency) {
        SourceTransparencySheet(
            onDismissRequest = { showSourceTransparency = false }
        )
    }

    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        item {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(modifier = Modifier.fillMaxWidth()) {
                    Text(
                        text = stringResource(R.string.research_title),
                        style = MaterialTheme.typography.headlineSmall
                    )
                    Spacer(modifier = Modifier.weight(1f))
                    IconButton(onClick = { showSourceTransparency = true }) {
                        Icon(
                            imageVector = Icons.Outlined.Info,
                            contentDescription = stringResource(R.string.source_transparency_button)
                        )
                    }
                }

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
                        Text(stringResource(R.string.research_retry))
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
                    text = stringResource(R.string.research_recent),
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
