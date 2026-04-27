package com.crisismap.app.domain.regions

import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle

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
