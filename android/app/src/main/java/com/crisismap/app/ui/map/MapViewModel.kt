package com.crisismap.app.ui.map

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.ThinkTankArticle
import com.crisismap.app.data.sources.NewsLoadResult
import com.crisismap.app.data.sources.NewsRepository
import com.crisismap.app.data.sources.ResearchLoadResult
import com.crisismap.app.data.sources.ResearchRepository
import com.crisismap.app.domain.regions.NewsClusterSummary
import com.crisismap.app.domain.regions.RegionIntelligenceSummary
import com.crisismap.app.domain.regions.buildRegionIntelligenceSummaries
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import java.time.Instant

data class MapUiState(
    val isLoading: Boolean = false,
    val events: List<CrisisEvent> = emptyList(),
    val eventMarkers: List<EventMapMarker> = emptyList(),
    val summaries: List<RegionIntelligenceSummary> = buildRegionIntelligenceSummaries(
        newsClusters = emptyList(),
        researchArticles = emptyList(),
        lastUpdatedAt = ""
    ),
    val errors: List<String> = emptyList()
)

class MapViewModel(
    private val newsRepository: NewsRepository = NewsRepository(),
    private val researchRepository: ResearchRepository = ResearchRepository()
) : ViewModel() {
    var uiState by mutableStateOf(MapUiState(isLoading = true))
        private set

    init {
        refresh()
    }

    fun refresh() {
        uiState = uiState.copy(isLoading = true, errors = emptyList())

        viewModelScope.launch {
            val newsDeferred = async { newsRepository.loadClusters() }
            val researchDeferred = async { researchRepository.loadArticles() }

            val newsResult = newsDeferred.await()
            val researchResult = researchDeferred.await()

            val clusters: List<NewsClusterSummary> = when (newsResult) {
                is NewsLoadResult.Success -> newsResult.clusters
                is NewsLoadResult.Failure -> emptyList()
            }
            val events: List<CrisisEvent> = when (newsResult) {
                is NewsLoadResult.Success -> newsResult.events
                is NewsLoadResult.Failure -> emptyList()
            }

            val articles: List<ThinkTankArticle> = when (researchResult) {
                is ResearchLoadResult.Success -> researchResult.articles
                is ResearchLoadResult.Failure -> emptyList()
            }

            val errors = buildList {
                if (newsResult is NewsLoadResult.Failure) add(newsResult.message)
                if (researchResult is ResearchLoadResult.Failure) add(researchResult.message)
            }

            uiState = MapUiState(
                isLoading = false,
                events = events,
                eventMarkers = buildEventMapMarkers(events),
                summaries = buildRegionIntelligenceSummaries(
                    newsClusters = clusters,
                    researchArticles = articles,
                    lastUpdatedAt = Instant.now().toString()
                ),
                errors = errors
            )
        }
    }
}
