package com.crisismap.app.ui.shell

import androidx.annotation.StringRes
import com.crisismap.app.R

enum class AppTab(
    @StringRes val labelRes: Int,
    val shortLabel: String
) {
    Map(labelRes = R.string.tab_map, shortLabel = "M"),
    News(labelRes = R.string.tab_news, shortLabel = "N"),
    Research(labelRes = R.string.tab_research, shortLabel = "R");

    companion object {
        val mvpVisible = listOf(Map, News, Research)
    }
}
