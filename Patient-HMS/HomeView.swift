import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Set the background color for the whole screen
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        GroupBox {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Upcoming Appointment")
                                
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Dr. Anjali Jaiswal, MD")
                                            .font(.headline)
                                        
                                        Text("Dermatologist")
                                            .font(.subheadline)
                                    }
                                }
                                .padding(.vertical, 3)
                                
                                HStack {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(.white)
                                        
                                        Text("Monday June 30, 2024")
                                            .foregroundColor(.white)
                                            .font(.system(size: 11.5, weight: .bold))
                                            .lineLimit(1)
                                        Spacer()
                                        Image(systemName: "calendar")
                                            .foregroundColor(.white)
                                        Text("10:00 - 11:00 am")
                                            .foregroundColor(.white)
                                            .font(.system(size: 10.6, weight: .bold))
                                    }
                                    .padding()
                                    .padding(.vertical, 1)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .frame(height: 70)
                                }
                            }
                            .padding(3)
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
//                                .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .padding()
                        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        HStack(spacing: 17) {
                            NavigationLink(destination: SearchView()) {
                                VStack {
                                    Image("DoctorImage")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.blue)
                                        .padding()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    
                                    Text("Book Appointment")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 8)
                                        .padding(.top, -13)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
//                                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                            
                            VStack {
                                Image("VideoCall")
                                    .resizable()
                                    .frame(width: 100, height: 120)
                                    .padding()
                                
                                Text("Instant Consult")
                                    .font(.headline)
                                    .padding(.bottom, 8)
                                    .padding(.top, -13)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        GroupBox {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Medical Records")
                                        .font(.headline)
                                        .padding(.bottom, 3)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                Divider()
                                
                                HStack {
                                    Text("Lab Records")
                                        .font(.headline)
                                        .padding(.bottom, 3)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                Divider()
                                
                                HStack {
                                    Text("Medical Bills")
                                        .font(.headline)
                                        .padding(.bottom, 3)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .padding()
                        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Spacer()
                    }
                    .navigationTitle("Home")
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
