package com.crisismap.app.domain.regions

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle
import com.crisismap.app.domain.locations.inferEventLocation

val mapMarkerRegions = listOf(
    Region.MiddleEast,
    Region.Europe,
    Region.EastAsia,
    Region.Africa,
    Region.Americas
)

fun Region.matchesArticle(article: ThinkTankArticle): Boolean {
    if (this == Region.All) return true

    val category = article.category.trim().lowercase()
    val topics = article.topics.map { it.trim() }.filter { it.isNotEmpty() }.toSet()

    return when (this) {
        Region.All -> true
        Region.MiddleEast -> category == "middle_east" || "Middle East" in topics
        Region.Europe -> category == "europe" || topics.any { it in europeTopics }
        Region.EastAsia -> category == "china_indopacific" || topics.any { it in eastAsiaTopics }
        Region.Africa -> category == "africa"
        Region.Americas -> category == "americas" || "United States" in topics
    }
}

private val europeTopics = setOf("Europe", "Russia", "Ukraine", "NATO")
private val eastAsiaTopics = setOf("China", "Taiwan", "Indo-Pacific")

fun relatedResearch(
    eventRegion: Region,
    entities: List<String>,
    articles: List<ThinkTankArticle>,
    limit: Int = 3
): List<ThinkTankArticle> {
    val normalizedEntities = entities.normalizedTerms()

    return articles
        .mapNotNull { article ->
            val regionMatch = eventRegion != Region.All && eventRegion.matchesArticle(article)
            val entityMatch = normalizedEntities.isNotEmpty() &&
                article.relevanceTerms().any { it in normalizedEntities }
            val isRelevant = if (normalizedEntities.isEmpty()) {
                regionMatch
            } else {
                regionMatch && entityMatch
            }

            if (!isRelevant) return@mapNotNull null

            RelatedResearchCandidate(
                article = article,
                score = (if (regionMatch) 2 else 0) + (if (entityMatch) 1 else 0)
            )
        }
        .sortedWith(
            compareByDescending<RelatedResearchCandidate> { it.score }
                .thenByDescending { it.article.date }
        )
        .take(limit)
        .map { it.article }
}

fun relatedResearchForEvent(
    event: CrisisEvent,
    articles: List<ThinkTankArticle>,
    limit: Int = 3
): List<ThinkTankArticle> {
    val region = inferEventLocation(
        title = event.title,
        summary = event.summary,
        providedName = event.location?.name,
        providedCountry = event.location?.country
    )?.region ?: inferEventRegion(event) ?: return emptyList()

    val entities = buildList {
        event.actor?.let(::add)
        event.entities?.let(::addAll)
    }

    return relatedResearch(
        eventRegion = region,
        entities = entities,
        articles = articles,
        limit = limit
    )
}

private data class RelatedResearchCandidate(
    val article: ThinkTankArticle,
    val score: Int
)

private fun inferEventRegion(event: CrisisEvent): Region? {
    val text = listOfNotNull(
        event.location?.name,
        event.location?.country,
        event.title,
        event.summary,
        event.actor,
        event.entities?.joinToString(" ")
    ).joinToString(" ")

    return mapMarkerRegions.firstOrNull { region ->
        region.matchesEventText(text)
    }
}

private fun ThinkTankArticle.relevanceTerms(): Set<String> =
    (topics + listOf(category, title, summary)).normalizedTerms()

private fun List<String>.normalizedTerms(): Set<String> =
    mapNotNull { term ->
        term
            .trim()
            .lowercase()
            .replace('_', ' ')
            .replace('-', ' ')
            .takeIf { it.isNotBlank() }
    }.toSet()

private fun Region.matchesEventText(text: String): Boolean {
    val lower = text.lowercase()
    return eventKeywords.any { it in lower }
}

private val Region.eventKeywords: Set<String>
    get() = when (this) {
        Region.All -> emptySet()
        Region.MiddleEast -> setOf(
            "iran",
            "iraq",
            "israel",
            "palestine",
            "gaza",
            "lebanon",
            "syria",
            "yemen",
            "saudi",
            "jordan",
            "egypt",
            "turkey",
            "qatar",
            "uae",
            "bahrain",
            "kuwait",
            "oman",
            "tehran",
            "baghdad",
            "beirut",
            "damascus",
            "sanaa",
            "riyadh",
            "jerusalem",
            "tel aviv",
            "west bank",
            "hezbollah",
            "hamas",
            "houthi",
            "irgc",
            "hormuz",
            "red sea",
            "suez"
        )
        Region.Europe -> setOf(
            "ukraine",
            "russia",
            "nato",
            "eu",
            "europe",
            "kyiv",
            "moscow",
            "london",
            "paris",
            "berlin",
            "brussels",
            "poland",
            "romania",
            "baltic",
            "crimea",
            "donbas",
            "belarus",
            "moldova"
        )
        Region.EastAsia -> setOf(
            "china",
            "taiwan",
            "japan",
            "korea",
            "beijing",
            "tokyo",
            "pyongyang",
            "seoul",
            "taipei",
            "south china sea",
            "xi jinping",
            "kim jong"
        )
        Region.Africa -> setOf(
            "africa",
            "sudan",
            "sahel",
            "somalia",
            "ethiopia",
            "congo",
            "nigeria",
            "libya",
            "mali",
            "niger",
            "burkina",
            "mozambique",
            "khartoum",
            "mogadishu",
            "addis ababa"
        )
        Region.Americas -> setOf(
            "us",
            "united states",
            "america",
            "washington",
            "pentagon",
            "mexico",
            "venezuela",
            "colombia",
            "brazil",
            "canada",
            "caribbean",
            "cuba"
        )
    }
