package com.crisismap.app.ui.shell

enum class AppTab(
    val label: String,
    val shortLabel: String
) {
    Map(label = "Map", shortLabel = "M"),
    News(label = "News", shortLabel = "N"),
    Research(label = "Research", shortLabel = "R");

    companion object {
        val mvpVisible = listOf(Map, News, Research)
    }
}
