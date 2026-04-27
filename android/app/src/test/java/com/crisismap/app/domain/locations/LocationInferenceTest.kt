package com.crisismap.app.domain.locations

import com.crisismap.app.data.model.Region
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class LocationInferenceTest {
    @Test
    fun prefersPhysicalLocationOverActorKeyword() {
        val result = inferEventLocation(
            title = "What's driving attacks against gov't and Russian forces in Mali?",
            summary = "Russian personnel remain exposed to attacks in Mali.",
            providedName = null,
            providedCountry = null
        )

        assertEquals("Mali", result?.location?.name)
        assertEquals("ML", result?.location?.country)
        assertEquals(Region.Africa, result?.region)
    }

    @Test
    fun returnsNullWhenNoReliableLocationExists() {
        val result = inferEventLocation(
            title = "NATO governments review support timelines",
            summary = "Security planning remains active.",
            providedName = null,
            providedCountry = null
        )

        assertNull(result)
    }
}
