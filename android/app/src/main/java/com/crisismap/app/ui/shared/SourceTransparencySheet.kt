package com.crisismap.app.ui.shared

import androidx.annotation.StringRes
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.crisismap.app.R

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SourceTransparencySheet(
    onDismissRequest: () -> Unit,
    modifier: Modifier = Modifier
) {
    ModalBottomSheet(onDismissRequest = onDismissRequest) {
        Column(
            modifier = modifier
                .fillMaxWidth()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp, vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = stringResource(R.string.source_transparency_title),
                    style = MaterialTheme.typography.titleLarge
                )
                Spacer(modifier = Modifier.weight(1f))
                TextButton(onClick = onDismissRequest) {
                    Text(stringResource(R.string.common_done))
                }
            }

            Text(
                text = stringResource(R.string.source_transparency_intro),
                style = MaterialTheme.typography.bodyMedium
            )

            SourceSection(
                titleRes = R.string.source_transparency_news_title,
                descriptionRes = R.string.source_transparency_news_description,
                sources = SourceTransparencyContent.newsSources
            )

            SourceSection(
                titleRes = R.string.source_transparency_research_title,
                descriptionRes = R.string.source_transparency_research_description,
                sources = SourceTransparencyContent.researchSources
            )

            TextSection(
                titleRes = R.string.source_transparency_organized_title,
                descriptionRes = R.string.source_transparency_organized_description
            )

            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    text = stringResource(R.string.source_transparency_limits_title),
                    style = MaterialTheme.typography.titleMedium
                )
                SourceTransparencyContent.limitations.forEach { limitation ->
                    Text(
                        text = stringResource(limitation.textRes),
                        style = MaterialTheme.typography.bodyMedium
                    )
                }
            }
        }
    }
}

@Composable
private fun SourceSection(
    @StringRes titleRes: Int,
    @StringRes descriptionRes: Int,
    sources: List<TransparencySource>
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            text = stringResource(titleRes),
            style = MaterialTheme.typography.titleMedium
        )
        Text(
            text = stringResource(descriptionRes),
            style = MaterialTheme.typography.bodyMedium
        )
        sources.forEach { source ->
            Column(verticalArrangement = Arrangement.spacedBy(2.dp)) {
                HorizontalDivider()
                Text(
                    text = source.name,
                    style = MaterialTheme.typography.bodyLarge
                )
                source.detailRes?.let { detailRes ->
                    Text(
                        text = stringResource(detailRes),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

@Composable
private fun TextSection(
    @StringRes titleRes: Int,
    @StringRes descriptionRes: Int
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            text = stringResource(titleRes),
            style = MaterialTheme.typography.titleMedium
        )
        Text(
            text = stringResource(descriptionRes),
            style = MaterialTheme.typography.bodyMedium
        )
    }
}
