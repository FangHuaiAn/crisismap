package com.crisismap.app.ui.shared

import androidx.annotation.StringRes
import com.crisismap.app.R

data class TransparencySource(
    val name: String,
    @StringRes val detailRes: Int? = null
)

data class TransparencyLimitation(
    @StringRes val textRes: Int
)

object SourceTransparencyContent {
    val newsSources = listOf(
        TransparencySource(name = "Reuters"),
        TransparencySource(name = "AP News"),
        TransparencySource(name = "BBC News"),
        TransparencySource(name = "NHK World"),
        TransparencySource(name = "Al Jazeera"),
        TransparencySource(name = "DW"),
        TransparencySource(name = "The Guardian"),
        TransparencySource(name = "NPR World"),
        TransparencySource(name = "France 24"),
        TransparencySource(name = "UN News"),
        TransparencySource(name = "GDELT", detailRes = R.string.source_transparency_news_gdelt),
        TransparencySource(name = "X/Grok", detailRes = R.string.source_transparency_news_x_grok)
    )

    val researchSources = listOf(
        TransparencySource(name = "Brookings"),
        TransparencySource(name = "CATO"),
        TransparencySource(name = "CFR"),
        TransparencySource(name = "CSIS"),
        TransparencySource(name = "Chatham House"),
        TransparencySource(name = "Foreign Affairs"),
        TransparencySource(name = "Heritage"),
        TransparencySource(name = "IISS"),
        TransparencySource(name = "INSS"),
        TransparencySource(name = "Mitchell"),
        TransparencySource(name = "RAND"),
        TransparencySource(name = "USNI")
    )

    val limitations = listOf(
        TransparencyLimitation(textRes = R.string.source_transparency_limit_coverage),
        TransparencyLimitation(textRes = R.string.source_transparency_limit_availability),
        TransparencyLimitation(textRes = R.string.source_transparency_limit_originals)
    )
}
