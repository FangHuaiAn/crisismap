package com.crisismap.app.ui.shared

import com.crisismap.app.R
import org.junit.Assert.assertTrue
import org.junit.Test

class SourceTransparencyContentTest {
    @Test
    fun newsSourcesIncludePublicCoverageAndOptionalSignals() {
        assertTrue(SourceTransparencyContent.newsSources.any { it.name == "Reuters" })
        assertTrue(SourceTransparencyContent.newsSources.any { it.name == "AP News" })
        assertTrue(SourceTransparencyContent.newsSources.any { it.name == "GDELT" })
        assertTrue(SourceTransparencyContent.newsSources.any { it.name == "X/Grok" })
    }

    @Test
    fun researchSourcesIncludeCoreThinkTanks() {
        assertTrue(SourceTransparencyContent.researchSources.any { it.name == "Brookings" })
        assertTrue(SourceTransparencyContent.researchSources.any { it.name == "CSIS" })
        assertTrue(SourceTransparencyContent.researchSources.any { it.name == "RAND" })
        assertTrue(SourceTransparencyContent.researchSources.any { it.name == "USNI" })
    }

    @Test
    fun limitationsIncludeCoverageCaveat() {
        assertTrue(
            SourceTransparencyContent.limitations.any {
                it.textRes == R.string.source_transparency_limit_coverage
            }
        )
    }
}
