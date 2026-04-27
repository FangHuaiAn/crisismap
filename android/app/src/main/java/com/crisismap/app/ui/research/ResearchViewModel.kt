package com.crisismap.app.ui.research

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle
import com.crisismap.app.data.sources.ResearchLoadResult
import com.crisismap.app.data.sources.ResearchRepository
import com.crisismap.app.domain.regions.matchesArticle
import com.crisismap.app.ui.regions.displayName
import kotlinx.coroutines.launch

data class ResearchUiState(
    val isLoading: Boolean = false,
    val articles: List<ThinkTankArticle> = emptyList(),
    val failedWeeks: List<String> = emptyList(),
    val error: String? = null
) {
    val rows: List<ResearchRegionRow> = buildResearchRegionRows(articles)
}

data class ResearchRegionRow(
    val region: Region,
    val title: String,
    val count: Int
)

fun buildResearchRegionRows(articles: List<ThinkTankArticle>): List<ResearchRegionRow> {
    return researchRegions.map { region ->
        val count = if (region == Region.All) {
            articles.size
        } else {
            articles.count { region.matchesArticle(it) }
        }

        ResearchRegionRow(
            region = region,
            title = region.displayName,
            count = count
        )
    }
}

val researchRegions = listOf(
    Region.All,
    Region.MiddleEast,
    Region.Europe,
    Region.EastAsia,
    Region.Africa,
    Region.Americas
)

class ResearchViewModel(
    private val repository: ResearchRepository = ResearchRepository()
) : ViewModel() {
    var uiState by mutableStateOf(ResearchUiState(isLoading = true))
        private set

    init {
        refresh()
    }

    fun refresh() {
        uiState = uiState.copy(isLoading = true, error = null)

        viewModelScope.launch {
            uiState = when (val result = repository.loadArticles()) {
                is ResearchLoadResult.Success -> ResearchUiState(
                    isLoading = false,
                    articles = result.articles,
                    failedWeeks = result.failedWeeks
                )

                is ResearchLoadResult.Failure -> ResearchUiState(
                    isLoading = false,
                    error = result.message,
                    failedWeeks = result.failedWeeks
                )
            }
        }
    }
}
