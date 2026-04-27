import MapKit
import SwiftUI

struct CrisisMapView: View {
    @Environment(EventsViewModel.self) private var viewModel

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 32, longitude: 50),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
        )
    )
    @State private var selectedEventId: String?

    var body: some View {
        ZStack {
            mapContent

            // Top bar overlay
            VStack {
                headerOverlay
                Spacer()
                legendOverlay
            }

            // Filter overlay — bottom left
            VStack {
                Spacer()
                HStack {
                    MapFilterOverlay()
                        .padding(.leading, 12)
                        .padding(.bottom, 8)
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.startPolling()
        }
        .onDisappear {
            viewModel.stopPolling()
        }
        .sheet(item: selectedEvent) { event in
            EventDetailSheet(event: event)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.bgSecondary)
        }
        .onChange(of: viewModel.selectedEventId) { _, newId in
            guard let newId,
                  let event = viewModel.events.first(where: { $0.id == newId }),
                  let coord = event.coordinate else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                position = .region(MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                ))
            }
            selectedEventId = newId
        }
    }

    // MARK: - Map

    private var mapContent: some View {
        Map(position: $position, selection: $selectedEventId) {
            ForEach(viewModel.eventsWithLocation) { event in
                if let coord = event.coordinate {
                    Annotation(event.title, coordinate: coord, anchor: .center) {
                        EventMarkerDot(level: event.level, isPrivate: event.isPrivate)
                            .onTapGesture {
                                selectedEventId = event.id
                            }
                    }
                    .tag(event.id)
                }
            }
        }
        .mapStyle(.imagery(elevation: .realistic))
        .mapControlVisibility(.visible)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Overlays

    private var headerOverlay: some View {
        HStack {
            HStack(spacing: 6) {
                Text("⊕")
                    .font(.title3)
                Text("CrisisMap")
                    .font(.headline.bold())
            }
            .foregroundStyle(Color.textPrimary)

            LiveIndicator()

            Spacer()

            Text("\(viewModel.eventsWithLocation.count) events")
                .font(.caption)
                .foregroundStyle(Color.textSecondary)

        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
        .padding(.bottom, 8)
        .background(
            LinearGradient(
                colors: [Color.bgPrimary.opacity(0.9), Color.bgPrimary.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var legendOverlay: some View {
        HStack(spacing: 10) {
            ForEach(ThreatLevel.allCases, id: \.self) { level in
                HStack(spacing: 3) {
                    Circle()
                        .fill(level.color)
                        .frame(width: 6, height: 6)
                    Text(level.label)
                        .font(.system(size: 9))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.bgSecondary.opacity(0.85))
        .clipShape(Capsule())
        .padding(.bottom, 8)
        .padding(.trailing, 50)
    }

    // MARK: - Helpers

    private var selectedEvent: Binding<CrisisEvent?> {
        Binding(
            get: {
                guard let id = selectedEventId else { return nil }
                return viewModel.events.first { $0.id == id }
            },
            set: { event in
                selectedEventId = event?.id
            }
        )
    }
}
