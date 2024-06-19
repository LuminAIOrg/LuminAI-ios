//
//  SensorView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import SwiftUI
import Charts


struct SensorView: View {
    
    var navigationColor: Color = Theme.Accents.red;
    var sensorId: Int;
    var sensorNameTemp: String;
    
    @State private var isPortrait: Bool = true
    
    @ObservedObject var viewModel = SensorViewModel()
    
    @EnvironmentObject var rotationManager: RotationManager
    
    init(sensorId: Int, sensorNameTemp: String) {
        print("Sensor page init")
        self.sensorId = sensorId;
        self.sensorNameTemp = sensorNameTemp;
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    if( UIDevice.isIPhone) {
                        if(isPortrait) {
                            Symbols.wave
                                .foregroundColor(navigationColor)
                                .ignoresSafeArea(edges: .top)
                                .frame(height: 600)
                        } else {
                            Symbols.waveHorizontal
                                .foregroundColor(navigationColor)
                                .ignoresSafeArea(edges: .all)
                        }
                    }
                    VStack {
                        if let sensor = viewModel.sensor {
                            Chart(sensor.data) {
                                LineMark(x: .value("Timestamp", Date(timeIntervalSince1970: Double($0.timestamp))), y: .value("Value", $0.value))
                                    .interpolationMethod(.monotone)
                            }
                            .chartScrollableAxes(.horizontal)
                            .chartScrollPosition(x: $viewModel.scrollPosition)
                            .onChange(of: viewModel.scrollPosition) {
                                print(viewModel.scrollPosition)
                            }
                            .frame(height: 200)
                            .modifier(ConditionalModifier(isPortrait: isPortrait, isGraph: true))
                        } else {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        
                        
                    }
                }
                .onAppear {
                    viewModel.clicked(sensorId: sensorId)
                    updateOrientation(size: geometry.size)
                }
                .onChange(of: geometry.size) {
                    updateOrientation(size: geometry.size)
                }
                
            }
            .navigationTitle(viewModel.sensor?.name ?? self.sensorNameTemp)
            .toolbarBackground(navigationColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {rotationManager.allowsRotation = true;}
        .onDisappear {rotationManager.allowsRotation = false;}
        .modifier(ConditionalModifier(isPortrait: isPortrait, isGraph: false))
        
    }
    
    private func updateOrientation(size: CGSize) {
        isPortrait = size.height > size.width
        print("isPortrait: \(isPortrait)")
    }
}

struct ConditionalModifier: ViewModifier {
    var isPortrait: Bool
    var isGraph: Bool

    func body(content: Content) -> some View {
        if(isGraph && !isPortrait) {
            content
                .offset(x: 20)
        } else {
            if isPortrait {
                content
            } else {
                content
                    .ignoresSafeArea(edges: .leading)
                    .offset(x: -20)
            }
        }
    }
}

#Preview {
    SensorView(sensorId: 51, sensorNameTemp: "TempName")
}
