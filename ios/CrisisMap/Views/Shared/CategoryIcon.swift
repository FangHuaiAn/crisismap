import SwiftUI

struct CategoryIcon: View {
    let category: EventCategory
    var size: CGFloat = 12

    var body: some View {
        Image(systemName: category.icon)
            .font(.system(size: size))
            .foregroundStyle(category.color)
    }
}

#Preview {
    HStack(spacing: 12) {
        ForEach(EventCategory.allCases, id: \.self) { cat in
            CategoryIcon(category: cat)
        }
    }
    .padding()
    .background(Color.bgPrimary)
}
