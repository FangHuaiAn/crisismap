package com.crisismap.app.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
enum class Region {
    @SerialName("all")
    All,

    @SerialName("middle-east")
    MiddleEast,

    @SerialName("europe")
    Europe,

    @SerialName("east-asia")
    EastAsia,

    @SerialName("africa")
    Africa,

    @SerialName("americas")
    Americas
}

@Serializable
enum class EventCategory {
    @SerialName("conflict")
    Conflict,

    @SerialName("statement")
    Statement,

    @SerialName("military")
    Military,

    @SerialName("diplomatic")
    Diplomatic,

    @SerialName("economic")
    Economic,

    @SerialName("terrorism")
    Terrorism,

    @SerialName("disaster")
    Disaster,

    @SerialName("prediction")
    Prediction,

    @SerialName("earthquake")
    Earthquake
}

@Serializable
enum class ThreatLevel {
    @SerialName("critical")
    Critical,

    @SerialName("high")
    High,

    @SerialName("medium")
    Medium,

    @SerialName("low")
    Low,

    @SerialName("info")
    Info
}

@Serializable
enum class SourceTier {
    @SerialName("public")
    Public,

    @SerialName("private")
    Private
}

@Serializable
enum class NewsSourceKind {
    @SerialName("wire")
    Wire,

    @SerialName("publisher")
    Publisher,

    @SerialName("aggregator")
    Aggregator,

    @SerialName("social")
    Social
}

@Serializable
enum class NewsSourceAttribution {
    @SerialName("direct")
    Direct,

    @SerialName("derived")
    Derived
}

@Serializable
data class Location(
    val lat: Double,
    val lng: Double,
    val name: String,
    val country: String? = null
)

@Serializable
data class NewsSourceDescriptor(
    val displayName: String,
    val kind: NewsSourceKind,
    val identity: String,
    val group: String,
    val attribution: NewsSourceAttribution,
    val originalOutlet: String? = null,
    val originCountry: String? = null,
    val languageCode: String? = null,
    val domain: String? = null,
    val authorHandle: String? = null
)

@Serializable
data class CrisisEvent(
    val id: String,
    val title: String,
    val summary: String,
    val category: EventCategory,
    val level: ThreatLevel,
    val location: Location? = null,
    val timestamp: String,
    val source: String,
    val sourceTier: SourceTier,
    val url: String? = null,
    val actor: String? = null,
    val entities: List<String>? = null,
    val newsSource: NewsSourceDescriptor? = null
)

@Serializable
data class WeekEntry(
    val week: String,
    val uploaded: String
)

@Serializable
data class WeekIndex(
    val weeks: List<WeekEntry>
)

@Serializable
data class TopicsIndex(
    val topics: List<String>
)

@Serializable
data class ThinkTankArticle(
    val id: String,
    @SerialName("think_tank")
    val thinkTank: String,
    val title: String,
    val url: String,
    val date: String,
    val summary: String = "",
    val category: String = "general",
    val status: String = "unknown",
    val topics: List<String> = emptyList()
)

@Serializable
data class ThinkTankWeekly(
    val week: String,
    @SerialName("start_date")
    val startDate: String,
    @SerialName("end_date")
    val endDate: String,
    @SerialName("generated_at")
    val generatedAt: String,
    val articles: List<ThinkTankArticle>
)
