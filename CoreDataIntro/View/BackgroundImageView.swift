//
//  BackgroundImageView.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//

import SwiftUI

struct BackgroundImageView: View {
  var body: some View {
    Image("2")
      .antialiased(true)
      .resizable()
      .scaledToFill()
      //.ignoresSafeArea(.all)
  }
}

struct BackgroundImageView_Previews: PreviewProvider {
  static var previews: some View {
    BackgroundImageView()
  }
}
