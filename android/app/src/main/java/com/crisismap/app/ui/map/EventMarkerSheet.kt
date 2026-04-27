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
import com.crisismap.app.data.model.CrisisEvent

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EventMarkerSheet(
    event: CrisisEvent,
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
                text = event.title,
                style = MaterialTheme.typography.headlineSmall
            )
            Text(
                text = event.location?.name ?: "Unplaced event",
                style = MaterialTheme.typography.bodyMedium
            )

            HorizontalDivider()

            ListItem(
                headlineContent = { Text("Source") },
                supportingContent = { Text("${event.source} | ${event.timestamp}") }
            )

            ListItem(
                headlineContent = { Text("Threat") },
                supportingContent = { Text(event.level.name) }
            )

            event.actor?.let { actor ->
                ListItem(
                    headlineContent = { Text("Actor") },
                    supportingContent = { Text(actor) }
                )
            }

            event.entities
                ?.takeIf { it.isNotEmpty() }
                ?.let { entities ->
                    ListItem(
                        headlineContent = { Text("Entities") },
                        supportingContent = { Text(entities.joinToString(", ")) }
                    )
                }

            if (event.summary.isNotBlank()) {
                HorizontalDivider()
                Text(
                    text = event.summary,
                    style = MaterialTheme.typography.bodyLarge
                )
            }
        }
    }
}
