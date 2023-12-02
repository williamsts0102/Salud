//
//  TiendaViewController.swift
//  Salud
//
//  Created by DAMII on 29/11/23.
//

import UIKit
import Alamofire
import Kingfisher

class TiendaViewController: UIViewController {

    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [String] = []
    private var myData: [Medicamento] = []
    private var filteredData: [Medicamento] = []
    
    private let myCellWidth = UIScreen.main.bounds.width / 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tienda"
        fetchDataFromAPI()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MyCustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "mycell")
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
    }
    
    private func fetchDataFromAPI() {
        AF.request("https://apisalud.wendyhuaman.com/api/listMedicamentos").responseDecodable(of: SuccessListMedicamento.self) { response in
            switch response.result {
            case .success(let data):
                self.myData = data.medicamentos
                self.collectionView.reloadData()
                self.categories = self.obtenerCategoriasUnicas()
                DispatchQueue.main.async {
                    self.categoryPickerView.reloadAllComponents()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
            filteredData = myData.filter { medicamento in
                return medicamento.nombre.lowercased().contains(textField.text?.lowercased() ?? "")
            }

            collectionView.reloadData()
    }
    
    func obtenerCategoriasUnicas() -> [String] {
        let categoriasUnicas = Set(myData.compactMap { $0.id_categoria })
        let categoriasArray = Array(categoriasUnicas)
        print("Categorías únicas: \(categoriasArray)")
        return categoriasArray
    }
    
}


extension TiendaViewController: UICollectionViewDataSource{
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if !filteredData.isEmpty {
                return filteredData.count
            }
            return myData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as? MyCustomCollectionViewCell

            let medicamento: Medicamento
            if !filteredData.isEmpty {
                medicamento = filteredData[indexPath.row]
            } else {
                medicamento = myData[indexPath.row]
            }
            print("Nombre del medicamento: \(medicamento.nombre)")
        
            cell?.myFirstLabel.text = medicamento.nombre
            let url = URL(string: medicamento.imagen)
            cell?.myImage.kf.setImage(with: url)
        return cell!
    }
}

extension TiendaViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section) -> \(indexPath.row) \(myData[indexPath.row])")
        
        let medicamento: Medicamento
        if !filteredData.isEmpty {
            medicamento = filteredData[indexPath.row]
        } else {
            medicamento = myData[indexPath.row]
        }

        let medicamentoInfoVC = MedicamentoInfoViewController()

        medicamentoInfoVC.imagen = medicamento.imagen
        medicamentoInfoVC.nombre = medicamento.nombre
        medicamentoInfoVC.descripcion = medicamento.descripcion
        medicamentoInfoVC.precio = medicamento.precio
        medicamentoInfoVC.categoria = medicamento.id_categoria
        medicamentoInfoVC.unidades = medicamento.unidades

        self.navigationController?.pushViewController(medicamentoInfoVC, animated: true)

    }
}

extension TiendaViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: myCellWidth, height: myCellWidth)
    }
}

extension TiendaViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count + 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Todas"
        } else {
            let title = categories[row - 1]
            return title
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {

            filteredData = myData
        } else {
            let selectedCategory = categories[row - 1]
            filteredData = myData.filter { medicamento in
                return medicamento.id_categoria == selectedCategory
            }
        }

        collectionView.reloadData()
    }
}
