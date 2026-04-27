package com.crisismap.app.domain.locations

import com.crisismap.app.data.model.Location
import com.crisismap.app.data.model.Region

data class InferredEventLocation(
    val location: Location,
    val region: Region
)

fun inferEventLocation(
    title: String,
    summary: String,
    providedName: String?,
    providedCountry: String?
): InferredEventLocation? {
    val textFields = listOfNotNull(providedName, providedCountry, title, summary)
    val normalizedCountry = providedCountry?.trim()

    return strategicLocations.firstOrNull { candidate ->
        candidate.countryCode.equals(normalizedCountry, ignoreCase = true) ||
            textFields.any { field ->
                candidate.keywords.any { keyword -> field.containsTerm(keyword) }
            }
    }?.let { candidate ->
        InferredEventLocation(
            location = Location(
                lat = candidate.lat,
                lng = candidate.lng,
                name = candidate.name,
                country = candidate.countryCode
            ),
            region = candidate.region
        )
    }
}

private data class StrategicLocation(
    val name: String,
    val countryCode: String,
    val lat: Double,
    val lng: Double,
    val region: Region,
    val keywords: Set<String>
)

private val strategicLocations = listOf(
    StrategicLocation(
        name = "Mali",
        countryCode = "ML",
        lat = 17.5707,
        lng = -3.9962,
        region = Region.Africa,
        keywords = setOf("mali")
    )
)

private fun String.containsTerm(term: String): Boolean {
    val pattern = Regex("\\b${Regex.escape(term)}\\b", RegexOption.IGNORE_CASE)
    return pattern.containsMatchIn(this)
}
