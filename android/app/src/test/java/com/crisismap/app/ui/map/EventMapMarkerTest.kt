package com.crisismap.app.ui.map

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
import com.crisismap.app.data.model.Location
import com.crisismap.app.data.model.SourceTier
import com.crisismap.app.data.model.ThreatLevel
import org.junit.Assert.assertEquals
import org.junit.Test

class EventMapMarkerTest {
    @Test
    fun buildsEventMarkersFromLocatedEvents() {
        val markers = buildEventMapMarkers(
            listOf(
                event(
                    id = "mali",
                    title = "Mali defence minister killed",
                    location = Location(lat = 17.57, lng = -3.99, name = "Mali", country = "ML")
                )
            )
        )

        assertEquals(1, markers.size)
        assertEquals("mali", markers.first().eventId)
        assertEquals("Mali defence minister killed", markers.first().title)
        assertEquals("Mali", markers.first().snippet)
        assertEquals(17.57, markers.first().lat, 0.0001)
        assertEquals(-3.99, markers.first().lng, 0.0001)
        assertEquals(ThreatLevel.High, markers.first().threatLevel)
    }

    @Test
    fun excludesEventsWithoutLocationsFromEventMarkers() {
        assertEquals(emptyList<EventMapMarker>(), buildEventMapMarkers(listOf(event(location = null))))
    }

    private fun event(
        id: String = "fixture",
        title: String = "Fixture event",
        location: Location? = Location(lat = 0.0, lng = 0.0, name = "Fixture")
    ) = CrisisEvent(
        id = id,
        title = title,
        summary = "Fixture summary",
        category = EventCategory.Military,
        level = ThreatLevel.High,
        location = location,
        timestamp = "2026-04-26T00:00:00Z",
        source = "Fixture",
        sourceTier = SourceTier.Public,
        url = "https://example.com/$id"
    )
}
