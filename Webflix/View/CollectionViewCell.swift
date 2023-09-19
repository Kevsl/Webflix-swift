//
//  CollectionViewCell.swift
//  Webflix
//
//  Created by K on 19/09/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iv:UIImageView!
    @IBOutlet weak var movieTitle:UILabel!
    @IBOutlet weak var movieImage: UIImageView!
      
       
       var movie: Movie!
       
       func setup(_ newMovie:Movie){
           movie = newMovie
          

           
       }
    
    
    
    
}
