//
//  ViewController.swift
//  WarGameDesigner2
//
//  Created by Michael O'Connell on 5/8/20.
//  Copyright © 2020 Michael O'Connell. All rights reserved.
//

import Cocoa
import MKOGameFramework

let Padding: CGFloat = 20
let InitialCellHeight: CGFloat = 120
let InitialCellWidth: CGFloat = InitialCellHeight * 0.866
let BoardHeight: Int = 10
let BoardWidth: Int = 15

class ViewController: NSViewController {

    @IBOutlet weak var BoardView: NSView!
    @IBOutlet weak var SizeLabel: NSTextField!
    @IBOutlet weak var CurrentTerrainView: NSView!

    var CellHeight: CGFloat = InitialCellHeight
    var CellWidth: CGFloat = InitialCellWidth

    var mainBoard = GameBoard(rows: BoardHeight, cols: BoardWidth, cellHeight: InitialCellHeight)
    var currentTerrain = GameBoardCellTerrain.Grass

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        SizeLabel.stringValue = "Size: \(CellHeight)"
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor

        BoardView.wantsLayer = true

        BoardView.layer?.backgroundColor = NSColor.lightGray.cgColor

        BoardView.layer?.borderWidth = 1
        BoardView.layer?.borderColor = .black

        drawCells()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func drawCells() {
        for y in 0..<mainBoard.rows.count {
            for x in 0..<mainBoard.rows[y].cells.count {
                var newX = Padding + (CGFloat(x) * (CellWidth * 1.0))
                if (y % 2 == 1) {
                    newX = newX + (CellWidth / 2)
                }

                let newY = Padding + (CGFloat(y) * ((CellHeight * 0.7486)))

                mainBoard.rows[y].cells[x].view.frame = NSRect(x: newX, y: newY, width: CellWidth, height: CellHeight)
                mainBoard.rows[y].cells[x].view.tag = (y * 1000) + x

                BoardView.addSubview(mainBoard.rows[y].cells[x].view)

                let tapGesture = NSClickGestureRecognizer()
                tapGesture.target = self
                tapGesture.buttonMask = 0x1   // left button
                tapGesture.numberOfClicksRequired = 1
                tapGesture.action = #selector(self.click(g:))
                mainBoard.rows[y].cells[x].view.addGestureRecognizer(tapGesture)
            }
        }

    }
    
    
    @objc func click(g:NSGestureRecognizer) {
        if let v = g.view as? HexView {

            let touchpoint = g.location(in: v)

            if v.insideMask(x: touchpoint.x, y: touchpoint.y) {
                    // print("Inside Hexagon : \(v.tag)")

                let y: Int = v.tag / 1000
                let x: Int = v.tag % 1000

                mainBoard.rows[y].cells[x].setTerrain(terrain: currentTerrain)
            }
            else {
        //                print("Outside Hexagon")
            }

        }
    }


    @IBAction func ZoomOutButtonClick(_ sender: Any) {
        CellHeight = CellHeight * 0.5
        CellWidth = CellHeight * 0.866
        drawCells()
        SizeLabel.stringValue = "Size: \(CellHeight)"
        self.view.needsDisplay = true
    }


    @IBAction func ZoomInButtonClick(_ sender: Any) {
        CellHeight = CellHeight * 2.0
        CellWidth = CellHeight * 0.866
        drawCells()
        SizeLabel.stringValue = "Size: \(CellHeight)"
        self.view.needsDisplay = true
    }


    @IBAction func GrassButtonClick(_ sender: Any) {
        currentTerrain = .Grass
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor
    }


    @IBAction func WoodsButtonClick(_ sender: Any) {
        currentTerrain = .Woods
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor
    }


    @IBAction func WaterButtonClick(_ sender: Any) {
        currentTerrain = .Water
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor
    }


    @IBAction func DesertButtonClick(_ sender: Any) {
        currentTerrain = .Desert
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor
    }


    @IBAction func TundraButtonClick(_ sender: Any) {
        currentTerrain = .Tundra
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor
    }


    @IBAction func MountainButtonClick(_ sender: Any) {
        currentTerrain = .Mountain
        CurrentTerrainView.layer?.backgroundColor = currentTerrain.toColor().cgColor
    }


    @IBAction func OpenFile(_ sender: Any) {
        print("Open file menu option")

        let dialog = NSOpenPanel()

        dialog.title                   = "Open File|Sand Creek Studio"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories    = false
        dialog.allowedFileTypes        = ["xml"]
        dialog.nameFieldStringValue    = "saveboard.xml"

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                let path: String = result!.path

                if path != "" {
                    let saveResult = mainBoard.OpenFile(path: path)

                    if saveResult == false {
                        print("File open failed")
                    }
                    else {
                        print("File open successful")
                    }
                }
            }
            else {
                print("Error:  code should never reach this point!")
            }
        } else {
            // User clicked on "Cancel"
        }
    }


    @IBAction func SaveFile(_ sender: Any) {
        print("Save file menu option")

        if mainBoard.path == "" {
            let dialog = NSSavePanel()

            dialog.title                   = "Save File|Sand Creek Studio"
            dialog.showsResizeIndicator    = true
            dialog.canCreateDirectories    = true
            dialog.showsHiddenFiles        = false
            dialog.allowedFileTypes        = ["xml"]
            dialog.nameFieldStringValue    = "saveboard.xml"

            if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
                let result = dialog.url // Pathname of the file

                if (result != nil) {
                    let path: String = result!.path
                    let saveResult = mainBoard.SaveFile(path: path)

                    if saveResult == false {
                        print("File save failed")
                    }
                    else {
                        print("File save successful")
                    }
                }
                else {
                    print("Error:  code should never reach this point!")
                }
            } else {
                // User clicked on "Cancel"
            }
        }
        else {
            let saveResult = mainBoard.SaveFile(path: mainBoard.path)

            if saveResult == false {
                print("File save failed")
            }
            else {
                print("File save successful")
            }

        }
    }

}

