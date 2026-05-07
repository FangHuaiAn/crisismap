package com.crisismap.app.data.sources

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.NewsSourceAttribution
import com.crisismap.app.data.model.NewsSourceKind
import com.crisismap.app.data.model.Region
import com.crisismap.app.domain.locations.inferEventLocation
import com.crisismap.app.domain.regions.NewsClusterSummary
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope

sealed interface NewsLoadResult {
    data class Success(
        val events: List<CrisisEvent>,
        val clusters: List<NewsClusterSummary>,
        val failedSources: List<String>
    ) : NewsLoadResult

    data class Failure(
        val message: String,
        val failedSources: List<String>
    ) : NewsLoadResult
}

class NewsRepository(
    private val sources: List<NewsDataSource> = listOf(RssNewsSource(), GdeltNewsSource()),
    private val fallbackSource: NewsDataSource = FixtureNewsSource()
) {
    suspend fun loadClusters(): NewsLoadResult {
        val results = coroutineScope {
            sources.map { source ->
                async {
                    runCatching { source.fetch() }
                        .fold(
                            onSuccess = { NewsFetchResult.Success(source.id, it) },
                            onFailure = { NewsFetchResult.Failure(source.id) }
                        )
                }
            }.awaitAll()
        }

        val liveEvents = results
            .filterIsInstance<NewsFetchResult.Success>()
            .flatMap { it.events }
        val failedSources = results
            .filterIsInstance<NewsFetchResult.Failure>()
            .map { it.sourceId }
            .sorted()

        val events = if (liveEvents.isEmpty()) fallbackSource.fetch() else liveEvents
        val enrichedEvents = events.map(::enrichEvent)
        val clusters = buildNewsClusters(enrichedEvents)

        if (enrichedEvents.isEmpty()) {
            return NewsLoadResult.Failure(
                message = "No news available.",
                failedSources = failedSources
            )
        }

        return NewsLoadResult.Success(
            events = enrichedEvents,
            clusters = clusters,
            failedSources = failedSources
        )
    }

    private fun enrichEvent(event: CrisisEvent): CrisisEvent {
        if (event.location != null) return event

        val inferred = inferEventLocation(
            title = event.title,
            summary = event.summary,
            providedName = null,
            providedCountry = null
        ) ?: return event

        return event.copy(location = inferred.location)
    }
}

fun buildNewsClusters(events: List<CrisisEvent>): List<NewsClusterSummary> {
    return events
        .groupBy { inferRegion(it) }
        .filterKeys { it != Region.All }
        .map { (region, regionEvents) ->
            val sortedEvents = regionEvents.sortedByDescending { it.timestamp }
            val orderedKinds = listOf(
                NewsSourceKind.Wire,
                NewsSourceKind.Publisher,
                NewsSourceKind.Social,
                NewsSourceKind.Aggregator
            )
            val presentKinds = regionEvents.mapNotNull { it.newsSource?.kind }.toSet()
            NewsClusterSummary(
                id = "news-${region.name.lowercase()}",
                title = sortedEvents.first().title,
                region = region,
                eventCount = regionEvents.size,
                sourceCount = regionEvents.map { it.source }.distinct().size,
                score = regionEvents.maxOf { it.level.score },
                topics = listOf(region.name),
                lastUpdatedAt = sortedEvents.first().timestamp,
                sourceKinds = orderedKinds.filter { it in presentKinds },
                directSourceCount = regionEvents.count { it.newsSource?.attribution == NewsSourceAttribution.Direct },
                derivedSourceCount = regionEvents.count { it.newsSource?.attribution == NewsSourceAttribution.Derived }
            )
        }
        .sortedWith(compareByDescending<NewsClusterSummary> { it.score }.thenByDescending { it.eventCount })
}

private fun inferRegion(event: CrisisEvent): Region {
    val text = listOf(event.title, event.summary, event.location?.name, event.location?.country)
        .filterNotNull()
        .joinToString(" ")
        .lowercase()

    return when {
        listOf("taiwan", "china", "indo-pacific", "japan", "korea").any { it in text } -> Region.EastAsia
        listOf("middle east", "gaza", "israel", "iran", "syria", "red sea").any { it in text } -> Region.MiddleEast
        listOf("africa", "sudan", "sahel", "ethiopia", "mali").any { it in text } -> Region.Africa
        listOf("europe", "ukraine", "russia", "nato").any { it in text } -> Region.Europe
        listOf("america", "united states", "venezuela", "mexico", "caribbean").any { it in text } -> Region.Americas
        else -> Region.All
    }
}

private val com.crisismap.app.data.model.ThreatLevel.score: Double
    get() = when (this) {
        com.crisismap.app.data.model.ThreatLevel.Critical -> 1.0
        com.crisismap.app.data.model.ThreatLevel.High -> 0.8
        com.crisismap.app.data.model.ThreatLevel.Medium -> 0.6
        com.crisismap.app.data.model.ThreatLevel.Low -> 0.4
        com.crisismap.app.data.model.ThreatLevel.Info -> 0.2
    }

private sealed interface NewsFetchResult {
    data class Success(
        val sourceId: String,
        val events: List<CrisisEvent>
    ) : NewsFetchResult

    data class Failure(
        val sourceId: String
    ) : NewsFetchResult
}
