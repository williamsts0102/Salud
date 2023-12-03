//
//  CarritoVC.swift
//  Salud
//
//  Created by Charly Vasquez on 2/12/23.
//

import UIKit

class CarritoVC: UIViewController {
    
    

    @IBOutlet weak var carritoTableView: UITableView!
    
    var nombre: String = ""
    var listCarrito = ["Medicina 1",
                   "Medicina 2",
                   "Medicina 3",
                   "Medicina 4",
                   "Medicina 5"
    ]
    var medicamentoAlCarrito:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carritoTableView.delegate = self
        carritoTableView.dataSource = self
        
        carritoTableView.register(UINib(nibName: "ItemCarritoTableViewCell", bundle: nil), forCellReuseIdentifier: "itemTVC")
//        ordersTV.register(UINib(nibName: "NewOrderTVCell", bundle: nil), forCellReuseIdentifier: NewOrderTVCell.identifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        medicamentoAlCarrito.append(nombre)
    }




}

extension CarritoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicamentoAlCarrito.count
//        return listCarrito.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = carritoTableView.dequeueReusableCell(withIdentifier: "itemTVC", for: indexPath) as! ItemCarritoTableViewCell
//        cell.lblItemCarrito.text = listCarrito[indexPath.item]
        cell.lblItemCarrito.text = medicamentoAlCarrito[indexPath.item]
//        cell.configView(arrListOrders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            tableView.beginUpdates()
//            listCarrito.remove(at: indexPath.row)
            medicamentoAlCarrito.remove(at: indexPath.row)
//            UserData.shared.typeExtras.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}
