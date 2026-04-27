package com.crisismap.app.data.sources

import com.crisismap.app.data.model.ThinkTankArticle
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope

sealed interface ResearchLoadResult {
    data class Success(
        val articles: List<ThinkTankArticle>,
        val failedWeeks: List<String>
    ) : ResearchLoadResult

    data class Failure(
        val message: String,
        val failedWeeks: List<String>
    ) : ResearchLoadResult
}

class ResearchRepository(
    private val api: ThinkTankApi = HttpThinkTankApi()
) {
    suspend fun loadArticles(): ResearchLoadResult {
        val weekIndex = try {
            api.fetchWeekIndex()
        } catch (error: Exception) {
            return ResearchLoadResult.Failure(
                message = error.message ?: "Failed to fetch research week index.",
                failedWeeks = emptyList()
            )
        }

        if (weekIndex.weeks.isEmpty()) {
            return ResearchLoadResult.Success(articles = emptyList(), failedWeeks = emptyList())
        }

        val results = coroutineScope {
            weekIndex.weeks.map { entry ->
                async {
                    runCatching { api.fetchWeekly(entry.week).articles }
                        .fold(
                            onSuccess = { WeekFetchResult.Success(entry.week, it) },
                            onFailure = { WeekFetchResult.Failure(entry.week, it.message ?: "unknown error") }
                        )
                }
            }.awaitAll()
        }

        val articles = results
            .filterIsInstance<WeekFetchResult.Success>()
            .flatMap { it.articles }
            .sortedByDescending { it.date }

        val failedWeeks = results
            .filterIsInstance<WeekFetchResult.Failure>()
            .map { it.week }
            .sorted()

        if (articles.isEmpty() && failedWeeks.isNotEmpty()) {
            return ResearchLoadResult.Failure(
                message = "Failed to load research data from all weeks.",
                failedWeeks = failedWeeks
            )
        }

        return ResearchLoadResult.Success(
            articles = articles,
            failedWeeks = failedWeeks
        )
    }
}

private sealed interface WeekFetchResult {
    data class Success(
        val week: String,
        val articles: List<ThinkTankArticle>
    ) : WeekFetchResult

    data class Failure(
        val week: String,
        val message: String
    ) : WeekFetchResult
}
