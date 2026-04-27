package com.crisismap.app.ui.news

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.crisismap.app.data.sources.NewsLoadResult
import com.crisismap.app.data.sources.NewsRepository
import com.crisismap.app.domain.regions.NewsClusterSummary
import kotlinx.coroutines.launch

data class NewsUiState(
    val isLoading: Boolean = false,
    val clusters: List<NewsClusterSummary> = emptyList(),
    val failedSources: List<String> = emptyList(),
    val error: String? = null
)

class NewsViewModel(
    private val repository: NewsRepository = NewsRepository()
) : ViewModel() {
    var uiState by mutableStateOf(NewsUiState(isLoading = true))
        private set

    init {
        refresh()
    }

    fun refresh() {
        uiState = uiState.copy(isLoading = true, error = null)

        viewModelScope.launch {
            uiState = when (val result = repository.loadClusters()) {
                is NewsLoadResult.Success -> NewsUiState(
                    isLoading = false,
                    clusters = result.clusters,
                    failedSources = result.failedSources
                )

                is NewsLoadResult.Failure -> NewsUiState(
                    isLoading = false,
                    error = result.message,
                    failedSources = result.failedSources
                )
            }
        }
    }
}
