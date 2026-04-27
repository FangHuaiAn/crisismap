package com.crisismap.app.ui.shell

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.foundation.layout.padding
import com.crisismap.app.ui.map.MapScreen
import com.crisismap.app.ui.news.NewsScreen
import com.crisismap.app.ui.research.ResearchScreen

@Composable
fun CrisisMapApp() {
    MaterialTheme {
        Surface {
            var selectedTab by rememberSaveable { mutableStateOf(AppTab.Map) }

            Scaffold(
                bottomBar = {
                    NavigationBar {
                        AppTab.mvpVisible.forEach { tab ->
                            NavigationBarItem(
                                selected = selectedTab == tab,
                                onClick = { selectedTab = tab },
                                icon = { Text(tab.shortLabel) },
                                label = { Text(tab.label) }
                            )
                        }
                    }
                }
            ) { paddingValues ->
                when (selectedTab) {
                    AppTab.Map -> MapScreen(modifier = Modifier.padding(paddingValues))
                    AppTab.News -> NewsScreen(modifier = Modifier.padding(paddingValues))
                    AppTab.Research -> ResearchScreen(modifier = Modifier.padding(paddingValues))
                }
            }
        }
    }
}
