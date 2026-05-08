import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // --- ESTRUCTURAS ---
    struct Usuario: Codable {
        let nombre: String
        let correo: String
        let contrasena: String
    }
    
    // Nueva estructura para Contactos de Confianza
    struct Contacto: Codable {
        var nombre: String
        var telefono: String
    }
    
    // Variable para identificar al usuario que inició sesión
    var usuarioLogueado: Usuario?
    
    // Lista dinámica de contactos
    var listaContactos: [Contacto] = []
    
    // --- VARIABLES PARA LA ALARMA (Independientes) ---
    var estaFlashActivo = false
    var estaAlarmaSonoraActiva = false
    var flashTimer: Timer?
    
    // Variable para el reproductor de audio
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Fondo blanco como tu mockup
        view.backgroundColor = .white
        
        // 2. CONFIGURAR LOGO (El icono rojo "E!")
        let imagenLogo = UIImageView()
        imagenLogo.image = UIImage(named: "LogoApp")
        imagenLogo.contentMode = .scaleAspectFit
        imagenLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagenLogo)
        
        // 3. CONFIGURAR TEXTO "EmergenciasYa!"
        let labelTitulo = UILabel()
        labelTitulo.text = "EmergenciasYa!"
        labelTitulo.textColor = .systemRed
        labelTitulo.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTitulo)
        
        // 4. POSICIONAR EN PANTALLA (Constraints)
        NSLayoutConstraint.activate([
            imagenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imagenLogo.widthAnchor.constraint(equalToConstant: 120),
            imagenLogo.heightAnchor.constraint(equalToConstant: 120),
            labelTitulo.topAnchor.constraint(equalTo: imagenLogo.bottomAnchor, constant: 20),
            labelTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // 5. ESPERAR 3 SEGUNDOS Y SALTAR AL LOGIN
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Queso, saltando al Login...")
            self.irALogin()
        }
    }
    
    func irALogin() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
       
        let imagenLogo = UIImageView(image: UIImage(named: "LogoApp"))
        imagenLogo.contentMode = .scaleAspectFit
        imagenLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagenLogo)
       
        let labelTitulo = UILabel()
        labelTitulo.text = "Inicio de Sesión"
        labelTitulo.font = .systemFont(ofSize: 30, weight: .bold)
        labelTitulo.textColor = UIColor(white: 0.1, alpha: 1.0)
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTitulo)
       
        let txtCorreo = UITextField()
        txtCorreo.placeholder = "Correo electrónico"
        txtCorreo.borderStyle = .roundedRect
        txtCorreo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtCorreo)
       
        // Actualizado: Ahora usa la función auxiliar para el botón de "ojo"
        let txtPassword = crearCampoTexto(p: "Contraseña", esSeguro: true)
        view.addSubview(txtPassword)
       
        let btnEntrar = UIButton(type: .system)
        btnEntrar.setTitle("Iniciar sesión", for: .normal)
        btnEntrar.backgroundColor = UIColor.systemRed
        btnEntrar.setTitleColor(.white, for: .normal)
        btnEntrar.layer.cornerRadius = 12
        btnEntrar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnEntrar)
        
        // --- LÓGICA DE VALIDACIÓN DE LOGIN (SOPORTE MULTIUSUARIO) ---
        btnEntrar.addAction(UIAction(handler: { _ in
            let email = txtCorreo.text ?? ""
            let pass = txtPassword.text ?? ""
            
            if email.isEmpty || pass.isEmpty {
                self.mostrarAlerta(titulo: "Campos Vacíos", msj: "Por favor, completa los datos.")
                return
            }
            
            // Cargamos la lista completa de usuarios
            let lista = self.cargarListaUsuarios()
            
            if let userEncontrado = lista.first(where: { $0.correo == email && $0.contrasena == pass }) {
                self.usuarioLogueado = userEncontrado
                self.irAHome()
            } else {
                self.mostrarAlerta(titulo: "Error", msj: "Correo o contraseña incorrectos.")
            }
        }), for: .touchUpInside)
       
        let btnHaciaRegistro = UIButton(type: .system)
        btnHaciaRegistro.setTitle("¿No tienes cuenta? Regístrate", for: .normal)
        btnHaciaRegistro.setTitleColor(.systemRed, for: .normal)
        btnHaciaRegistro.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        btnHaciaRegistro.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnHaciaRegistro)
        btnHaciaRegistro.addTarget(self, action: #selector(accionHaciaRegistro), for: .touchUpInside)
       
        NSLayoutConstraint.activate([
            imagenLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imagenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagenLogo.heightAnchor.constraint(equalToConstant: 130),
            imagenLogo.widthAnchor.constraint(equalToConstant: 130),
            labelTitulo.topAnchor.constraint(equalTo: imagenLogo.bottomAnchor, constant: 40),
            labelTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            txtCorreo.topAnchor.constraint(equalTo: labelTitulo.bottomAnchor, constant: 50),
            txtCorreo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            txtCorreo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            txtCorreo.heightAnchor.constraint(equalToConstant: 55),
            txtPassword.topAnchor.constraint(equalTo: txtCorreo.bottomAnchor, constant: 20),
            txtPassword.leadingAnchor.constraint(equalTo: txtCorreo.leadingAnchor),
            txtPassword.trailingAnchor.constraint(equalTo: txtCorreo.trailingAnchor),
            txtPassword.heightAnchor.constraint(equalToConstant: 55),
            btnEntrar.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 40),
            btnEntrar.leadingAnchor.constraint(equalTo: txtCorreo.leadingAnchor),
            btnEntrar.trailingAnchor.constraint(equalTo: txtCorreo.trailingAnchor),
            btnEntrar.heightAnchor.constraint(equalToConstant: 55),
            btnHaciaRegistro.topAnchor.constraint(equalTo: btnEntrar.bottomAnchor, constant: 30),
            btnHaciaRegistro.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // --- FUNCIONES DE ACCIÓN (PUENTES) ---
    
    @objc func accionHaciaRegistro() { irARegistro() }
    @objc func accionHaciaLogin() { irALogin() }
    @objc func accionHaciaHome() { irAHome() }
    @objc func accionHaciaConfig() { irAConfig() }
    @objc func accionHaciaAlarma() { irAAlarma() }
    
    @objc func accionHaciaEmergNums() {
        print("Cambiando a pantalla de Números de Emergencia...")
        irAEmergNums()
    }

    @objc func accionHaciaFirstAid() {
        print("Abriendo Guía de Primeros Auxilios...")
        irAFirstAid()
    }

    @objc func accionHaciaContactos() {
        print("Navegando a Contactos de Confianza...")
        irAContactos()
    }

    @objc func accionHaciaUbicacion() {
        print("Navegando a Compartir Ubicación...")
        irAUbicacion()
    }

    @objc func accionHaciaIncidentes() {
        print("Navegando a Registro de Incidentes...")
        irAIncidentes()
    }
    
    // --- PANTALLAS ---
    
    func irARegistro() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        let lblTitulo = UILabel()
        lblTitulo.text = "Crear cuenta"
        lblTitulo.font = .systemFont(ofSize: 28, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTitulo)
       
        let txtNombre = crearCampoTexto(p: "Nombre")
        let txtCorreo = crearCampoTexto(p: "Correo")
        let txtPass = crearCampoTexto(p: "Contraseña", esSeguro: true)
        let txtConfirm = crearCampoTexto(p: "Confirmar contraseña", esSeguro: true)
       
        let stackFields = UIStackView(arrangedSubviews: [txtNombre, txtCorreo, txtPass, txtConfirm])
        stackFields.axis = .vertical
        stackFields.spacing = 15
        stackFields.distribution = .fillEqually
        stackFields.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackFields)
       
        let btnRegistrar = UIButton(type: .system)
        btnRegistrar.setTitle("Registrar", for: .normal)
        btnRegistrar.backgroundColor = .systemRed
        btnRegistrar.setTitleColor(.white, for: .normal)
        btnRegistrar.layer.cornerRadius = 20
        btnRegistrar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnRegistrar)
       
        // --- LÓGICA DE REGISTRO CON ARREGLO (P3) ---
        btnRegistrar.addAction(UIAction(handler: { _ in
            guard let nom = txtNombre.text, !nom.isEmpty,
                  let email = txtCorreo.text, self.esCorreoValido(email),
                  let pass = txtPass.text, pass.count >= 6,
                  let conf = txtConfirm.text else {
                self.mostrarAlerta(titulo: "Atención", msj: "Datos incompletos o correo inválido. La clave debe tener 6+ caracteres.")
                return
            }
            
            if pass != conf {
                self.mostrarAlerta(titulo: "Error", msj: "Las contraseñas no coinciden.")
                return
            }
            
            // Obtener lista actual, agregar nuevo y guardar
            var usuarios = self.cargarListaUsuarios()
            let nuevoUser = Usuario(nombre: nom, correo: email, contrasena: pass)
            usuarios.append(nuevoUser)
           
            if let data = try? JSONEncoder().encode(usuarios) {
                UserDefaults.standard.set(data, forKey: "ListaUsuariosSIGMU")
                self.mostrarAlerta(titulo: "Éxito", msj: "Cuenta creada correctamente.")
                self.irALogin()
            }
        }), for: .touchUpInside)
       
        let btnVolver = UIButton(type: .system)
        btnVolver.setTitle("Ya tengo una cuenta", for: .normal)
        btnVolver.setTitleColor(.black, for: .normal)
        btnVolver.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnVolver)
        btnVolver.addTarget(self, action: #selector(accionHaciaLogin), for: .touchUpInside)
       
        NSLayoutConstraint.activate([
            lblTitulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            lblTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackFields.topAnchor.constraint(equalTo: lblTitulo.bottomAnchor, constant: 40),
            stackFields.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackFields.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            btnRegistrar.topAnchor.constraint(equalTo: stackFields.bottomAnchor, constant: 30),
            btnRegistrar.leadingAnchor.constraint(equalTo: stackFields.leadingAnchor),
            btnRegistrar.trailingAnchor.constraint(equalTo: stackFields.trailingAnchor),
            btnRegistrar.heightAnchor.constraint(equalToConstant: 50),
            btnVolver.topAnchor.constraint(equalTo: btnRegistrar.bottomAnchor, constant: 20),
            btnVolver.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func irAHome() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
       
        // --- BARRA ROJA DE BIENVENIDA (P3) ---
        let barraBienvenida = UIView()
        barraBienvenida.backgroundColor = .systemRed
        barraBienvenida.layer.cornerRadius = 10
        barraBienvenida.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barraBienvenida)
       
        let lblBienvenida = UILabel()
        lblBienvenida.text = "Bienvenido, \(usuarioLogueado?.nombre ?? "Usuario")"
        lblBienvenida.textColor = .white
        lblBienvenida.font = .systemFont(ofSize: 16, weight: .bold)
        lblBienvenida.translatesAutoresizingMaskIntoConstraints = false
        barraBienvenida.addSubview(lblBienvenida)
       
        let btnSOS = UIButton(type: .custom)
        btnSOS.setTitle("SOS", for: .normal)
        btnSOS.titleLabel?.font = .systemFont(ofSize: 45, weight: .bold)
        btnSOS.backgroundColor = .systemRed
        btnSOS.setTitleColor(.white, for: .normal)
        let tamanoSOS: CGFloat = 180
        btnSOS.layer.cornerRadius = tamanoSOS / 2
        btnSOS.layer.shadowColor = UIColor.black.cgColor
        btnSOS.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnSOS.layer.shadowRadius = 10
        btnSOS.layer.shadowOpacity = 0.3
       
        btnSOS.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnSOS)
        btnSOS.isUserInteractionEnabled = true
        btnSOS.addTarget(self, action: #selector(accionHaciaAlarma), for: .touchUpInside)
       
        let btnSettings = UIButton(type: .system)
        btnSettings.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        btnSettings.tintColor = .gray
        btnSettings.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnSettings)
        btnSettings.addTarget(self, action: #selector(accionHaciaConfig), for: .touchUpInside)
       
        let stackOpciones = UIStackView()
        stackOpciones.axis = .vertical
        stackOpciones.spacing = 12
        stackOpciones.distribution = .fillEqually
        stackOpciones.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackOpciones)
       
        let datos = [
            ("phone.fill", "Números De Emergencia", UIColor.systemBlue),
            ("plus.app.fill", "Primeros Auxilios", UIColor.systemPink),
            ("person.crop.circle.fill", "Contactos de Confianza", UIColor.systemOrange),
            ("mappin.and.ellipse", "Compartir Ubicación", UIColor.systemGreen),
            ("clock.arrow.circlepath", "Registro de incidentes", UIColor.systemGray)
        ]
       
        for (icono, titulo, color) in datos {
            let vistaBoton = crearBotonOpcion(icono: icono, titulo: titulo, colorIcono: color)
            vistaBoton.isUserInteractionEnabled = true
           
            if titulo == "Números De Emergencia" {
                let tap = UITapGestureRecognizer(target: self, action: #selector(accionHaciaEmergNums))
                vistaBoton.addGestureRecognizer(tap)
            } else if titulo == "Primeros Auxilios" {
                let tap = UITapGestureRecognizer(target: self, action: #selector(accionHaciaFirstAid))
                vistaBoton.addGestureRecognizer(tap)
            } else if titulo == "Contactos de Confianza" {
                let tap = UITapGestureRecognizer(target: self, action: #selector(accionHaciaContactos))
                vistaBoton.addGestureRecognizer(tap)
            } else if titulo == "Compartir Ubicación" {
                let tap = UITapGestureRecognizer(target: self, action: #selector(accionHaciaUbicacion))
                vistaBoton.addGestureRecognizer(tap)
            } else if titulo == "Registro de incidentes" {
                let tap = UITapGestureRecognizer(target: self, action: #selector(accionHaciaIncidentes))
                vistaBoton.addGestureRecognizer(tap)
            }
            stackOpciones.addArrangedSubview(vistaBoton)
        }
       
        NSLayoutConstraint.activate([
            barraBienvenida.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            barraBienvenida.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            barraBienvenida.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            barraBienvenida.heightAnchor.constraint(equalToConstant: 40),
           
            lblBienvenida.centerXAnchor.constraint(equalTo: barraBienvenida.centerXAnchor),
            lblBienvenida.centerYAnchor.constraint(equalTo: barraBienvenida.centerYAnchor),

            btnSettings.topAnchor.constraint(equalTo: barraBienvenida.bottomAnchor, constant: 5),
            btnSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           
            btnSOS.topAnchor.constraint(equalTo: barraBienvenida.bottomAnchor, constant: 55),
            btnSOS.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnSOS.widthAnchor.constraint(equalToConstant: tamanoSOS),
            btnSOS.heightAnchor.constraint(equalToConstant: tamanoSOS),
           
            stackOpciones.topAnchor.constraint(equalTo: btnSOS.bottomAnchor, constant: 40),
            stackOpciones.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackOpciones.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            stackOpciones.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // --- CORRECCIÓN VISUAL Y FUNCIONAL: NÚMEROS DE EMERGENCIA ---
    func irAEmergNums() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        
        let header = UIView(); header.backgroundColor = .white; header.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(header)
        let btnB = UIButton(type: .system); btnB.setImage(UIImage(systemName: "chevron.left"), for: .normal); btnB.tintColor = .black; btnB.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside); btnB.translatesAutoresizingMaskIntoConstraints = false; header.addSubview(btnB)
        let lblT = UILabel(); lblT.text = "Números de Emergencia"; lblT.font = .systemFont(ofSize: 22, weight: .bold); lblT.translatesAutoresizingMaskIntoConstraints = false; header.addSubview(lblT)

        let scroll = UIScrollView(); scroll.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(scroll)
        let stackP = UIStackView(); stackP.axis = .vertical; stackP.spacing = 15; stackP.translatesAutoresizingMaskIntoConstraints = false; scroll.addSubview(stackP)
        
        // --- NÚMEROS OFICIALES EL SALVADOR ---
        let filas = [
            [("LogoPolicia", "PNC", "911", UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)),
             ("LogoBomberos", "Bomberos", "913", UIColor(red: 1.0, green: 0.88, blue: 0.88, alpha: 1.0))],
            [("LogoCruzRoja", "Cruz Roja", "2222-5155", UIColor(red: 1.0, green: 0.92, blue: 0.85, alpha: 1.0)),
             ("LogoCruzVerde", "Cruz Verde", "2284-5792", UIColor(red: 0.88, green: 1.0, blue: 0.88, alpha: 1.0))],
            [("LogoSalvamento", "Salvamento", "2133-0000", UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)),
             ("LogoProtCivil", "Prot. Civil", "2281-0888", UIColor(red: 0.95, green: 0.92, blue: 1.0, alpha: 1.0))],
            [("LogoAE", "AES", "2506-9000", UIColor(red: 0.92, green: 0.95, blue: 1.0, alpha: 1.0)),
             ("Logo123", "SEM / 132", "132", UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0))]
        ]
        
        for f in filas {
            let h = UIStackView(); h.axis = .horizontal; h.spacing = 15; h.distribution = .fillEqually
            h.heightAnchor.constraint(equalToConstant: 140).isActive = true // Altura fija para evitar el encimado
            for (img, txt, num, col) in f {
                h.addArrangedSubview(crearCajonEmergencia(imagen: img, titulo: txt, numero: num, fondo: col))
            }
            stackP.addArrangedSubview(h)
        }
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), header.leadingAnchor.constraint(equalTo: view.leadingAnchor), header.trailingAnchor.constraint(equalTo: view.trailingAnchor), header.heightAnchor.constraint(equalToConstant: 60),
            btnB.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 15), btnB.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            lblT.centerXAnchor.constraint(equalTo: header.centerXAnchor), lblT.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            scroll.topAnchor.constraint(equalTo: header.bottomAnchor), scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackP.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20), stackP.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 20), stackP.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -20), stackP.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -20), stackP.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -40)
        ])
    }

    func crearCajonEmergencia(imagen: String, titulo: String, numero: String, fondo: UIColor) -> UIView {
        let v = UIView(); v.backgroundColor = fondo; v.layer.cornerRadius = 20; v.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImageView(image: UIImage(named: imagen)); img.contentMode = .scaleAspectFit; img.translatesAutoresizingMaskIntoConstraints = false; v.addSubview(img)
        let lb = UILabel(); lb.text = titulo; lb.font = .systemFont(ofSize: 14, weight: .bold); lb.textAlignment = .center; lb.numberOfLines = 2; lb.translatesAutoresizingMaskIntoConstraints = false; v.addSubview(lb)
        let btn = UIButton(type: .custom); btn.translatesAutoresizingMaskIntoConstraints = false; v.addSubview(btn)
        
        btn.addAction(UIAction(handler: { _ in
            // ALERTA PERSONALIZADA SEGÚN EL NOMBRE SOLICITADO
            let alert = UIAlertController(title: "¿Desea llamar a \(titulo)?", message: "Se marcará al número: \(numero)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Llamar", style: .default, handler: { _ in self.llamarNumero(num: numero) }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            self.present(alert, animated: true)
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: v.centerXAnchor), img.topAnchor.constraint(equalTo: v.topAnchor, constant: 20), img.widthAnchor.constraint(equalToConstant: 65), img.heightAnchor.constraint(equalToConstant: 65),
            lb.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10), lb.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 5), lb.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -5),
            btn.topAnchor.constraint(equalTo: v.topAnchor), btn.leadingAnchor.constraint(equalTo: v.leadingAnchor), btn.trailingAnchor.constraint(equalTo: v.trailingAnchor), btn.bottomAnchor.constraint(equalTo: v.bottomAnchor)
        ])
        return v
    }

    func llamarNumero(num: String) {
        let clean = num.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(clean)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            self.mostrarAlerta(titulo: "Error", msj: "No se puede llamar desde este dispositivo.")
        }
    }

    func irAFirstAid() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
       
        let todasLasGuias = [
            (i: "flame.fill", t: "Quemaduras", d: "1. Enfríe con agua fresca.\n2. Cubra con paño limpio.\n3. No use hielo."),
            (i: "heart.fill", t: "RCP Básica", d: "1. Llame al 123.\n2. Inicie compresiones rítmicas.\n3. No pare hasta que llegue ayuda."),
            (i: "figure.stand", t: "Fracturas", d: "1. No mueva la zona.\n2. Inmovilice.\n3. Busque atención médica."),
            (i: "fork.knife", t: "Atragantamiento", d: "1. Maniobra de Heimlich.\n2. Presione arriba del ombligo.\n3. Expulse el objeto."),
            (i: "drop.fill", t: "Hemorragias", d: "1. Presión directa.\n2. Eleve el miembro.\n3. Vendaje compresivo.")
        ]
        
        let vistaHeader = UIView()
        vistaHeader.backgroundColor = .systemRed
        vistaHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vistaHeader)
       
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(btnBack)
       
        let lblTitulo = UILabel()
        lblTitulo.text = "Guía de Primeros Auxilios"
        lblTitulo.textColor = .white
        lblTitulo.font = .systemFont(ofSize: 20, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(lblTitulo)
       
        let txtBuscar = UITextField()
        txtBuscar.placeholder = "Buscar una situación..."
        txtBuscar.backgroundColor = .white
        txtBuscar.borderStyle = .roundedRect
        txtBuscar.layer.cornerRadius = 10
        txtBuscar.translatesAutoresizingMaskIntoConstraints = false
        txtBuscar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        txtBuscar.leftViewMode = .always
        view.addSubview(txtBuscar)
       
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
       
        let stackContenido = UIStackView()
        stackContenido.axis = .vertical
        stackContenido.spacing = 15
        stackContenido.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackContenido)
        
        func renderizar(lista: [(i: String, t: String, d: String)]) {
            stackContenido.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for item in lista {
                let celda = crearCeldaGuia(icono: item.i, titulo: item.t, subtitulo: "Toca para ver detalles")
                celda.isUserInteractionEnabled = true
                
                let btnAccion = UIButton(type: .custom)
                btnAccion.addAction(UIAction(handler: { _ in
                    let alert = UIAlertController(title: item.t, message: item.d, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
                    self.present(alert, animated: true)
                }), for: .touchUpInside)
                
                btnAccion.translatesAutoresizingMaskIntoConstraints = false
                celda.addSubview(btnAccion)
                NSLayoutConstraint.activate([
                    btnAccion.topAnchor.constraint(equalTo: celda.topAnchor),
                    btnAccion.bottomAnchor.constraint(equalTo: celda.bottomAnchor),
                    btnAccion.leadingAnchor.constraint(equalTo: celda.leadingAnchor),
                    btnAccion.trailingAnchor.constraint(equalTo: celda.trailingAnchor)
                ])
                
                stackContenido.addArrangedSubview(celda)
            }
        }
        
        txtBuscar.addAction(UIAction(handler: { _ in
            let q = txtBuscar.text?.lowercased() ?? ""
            renderizar(lista: q.isEmpty ? todasLasGuias : todasLasGuias.filter { $0.t.lowercased().contains(q) })
        }), for: .editingChanged)
        
        renderizar(lista: todasLasGuias)
       
        NSLayoutConstraint.activate([
            vistaHeader.topAnchor.constraint(equalTo: view.topAnchor),
            vistaHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaHeader.heightAnchor.constraint(equalToConstant: 110),
            btnBack.leadingAnchor.constraint(equalTo: vistaHeader.leadingAnchor, constant: 20),
            btnBack.bottomAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: -15),
            lblTitulo.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor),
            lblTitulo.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 15),
            txtBuscar.topAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: 20),
            txtBuscar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            txtBuscar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            txtBuscar.heightAnchor.constraint(equalToConstant: 45),
            scrollView.topAnchor.constraint(equalTo: txtBuscar.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackContenido.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackContenido.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackContenido.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackContenido.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackContenido.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    func irAContactos() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
       
        // Cargar contactos guardados
        self.listaContactos = cargarContactos()
        
        let vistaHeader = UIView()
        vistaHeader.backgroundColor = .systemRed
        vistaHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vistaHeader)
       
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(btnBack)
       
        let lblTitulo = UILabel()
        lblTitulo.text = "Contactos de Confianza"
        lblTitulo.textColor = .white
        lblTitulo.font = .systemFont(ofSize: 20, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(lblTitulo)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
       
        let stackContactos = UIStackView()
        stackContactos.axis = .vertical
        stackContactos.spacing = 15
        stackContactos.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackContactos)
       
        let vistaVacia = UIStackView()
        vistaVacia.axis = .vertical
        vistaVacia.alignment = .center
        vistaVacia.spacing = 15
        vistaVacia.translatesAutoresizingMaskIntoConstraints = false
        
        let imgVacia = UIImageView(image: UIImage(systemName: "person.crop.circle.badge.plus"))
        imgVacia.tintColor = .systemGray3
        imgVacia.contentMode = .scaleAspectFit
        
        let lblMensaje = UILabel()
        lblMensaje.text = "No hay contactos de confianza"
        lblMensaje.font = .systemFont(ofSize: 18, weight: .medium)
        lblMensaje.textColor = .darkGray
        
        vistaVacia.addArrangedSubview(imgVacia)
        vistaVacia.addArrangedSubview(lblMensaje)
        view.addSubview(vistaVacia)
        
        func refrescarLista() {
            stackContactos.arrangedSubviews.forEach { $0.removeFromSuperview() }
            if listaContactos.isEmpty {
                vistaVacia.isHidden = false
            } else {
                vistaVacia.isHidden = true
                for (index, con) in listaContactos.enumerated() {
                    let tarjeta = crearTarjetaContacto(c: con)
                    tarjeta.isUserInteractionEnabled = true
                    
                    // Acción para abrir menú de opciones
                    let tapMenu = UIAction(handler: { _ in
                        let menu = UIAlertController(title: con.nombre, message: "¿Qué deseas hacer?", preferredStyle: .actionSheet)
                        
                        menu.addAction(UIAlertAction(title: "Editar", style: .default, handler: { _ in
                            self.mostrarVentanaFlotanteContacto(esEdicion: true, index: index, alFinalizar: refrescarLista)
                        }))
                        
                        menu.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { _ in
                            self.listaContactos.remove(at: index)
                            self.guardarContactos(self.listaContactos)
                            refrescarLista()
                        }))
                        
                        menu.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
                        self.present(menu, animated: true)
                    })
                    
                    // Botón invisible sobre la tarjeta (excepto sobre el botón de llamada)
                    let btnCuerpo = UIButton(type: .custom)
                    btnCuerpo.addAction(tapMenu, for: .touchUpInside)
                    btnCuerpo.translatesAutoresizingMaskIntoConstraints = false
                    tarjeta.addSubview(btnCuerpo)
                    NSLayoutConstraint.activate([
                        btnCuerpo.topAnchor.constraint(equalTo: tarjeta.topAnchor),
                        btnCuerpo.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor),
                        btnCuerpo.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor),
                        btnCuerpo.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -60)
                    ])
                    
                    stackContactos.addArrangedSubview(tarjeta)
                }
            }
        }
       
        let btnAdd = UIButton(type: .custom)
        btnAdd.backgroundColor = .systemRed
        btnAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        btnAdd.tintColor = .white
        btnAdd.layer.cornerRadius = 28
        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnAdd)
        
        btnAdd.addAction(UIAction(handler: { _ in
            self.mostrarVentanaFlotanteContacto(esEdicion: false, index: 0, alFinalizar: refrescarLista)
        }), for: .touchUpInside)
       
        NSLayoutConstraint.activate([
            vistaHeader.topAnchor.constraint(equalTo: view.topAnchor),
            vistaHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaHeader.heightAnchor.constraint(equalToConstant: 110),
            btnBack.leadingAnchor.constraint(equalTo: vistaHeader.leadingAnchor, constant: 20),
            btnBack.bottomAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: -15),
            lblTitulo.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor),
            lblTitulo.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 15),
            
            scrollView.topAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackContactos.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackContactos.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackContactos.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackContactos.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            vistaVacia.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vistaVacia.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imgVacia.widthAnchor.constraint(equalToConstant: 100),
            imgVacia.heightAnchor.constraint(equalToConstant: 100),
            
            btnAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            btnAdd.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btnAdd.widthAnchor.constraint(equalToConstant: 56),
            btnAdd.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        refrescarLista()
    }
    
    // Función centralizada para Agregar/Editar contacto con ADVERTENCIA DE 8 DÍGITOS
    func mostrarVentanaFlotanteContacto(esEdicion: Bool, index: Int, alFinalizar: @escaping () -> Void) {
        let titulo = esEdicion ? "Editar Contacto" : "Nuevo Contacto"
        let msg = esEdicion ? "Modifica los datos" : "Añade nombre y teléfono"
        let alert = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "Nombre"
            if esEdicion { tf.text = self.listaContactos[index].nombre }
        }
        alert.addTextField { tf in
            tf.placeholder = "Teléfono (8 dígitos)"
            tf.keyboardType = .phonePad
            if esEdicion { tf.text = self.listaContactos[index].telefono }
        }
        
        let actionSave = UIAlertAction(title: "Guardar", style: .default) { _ in
            let n = alert.textFields?[0].text ?? ""
            let t = alert.textFields?[1].text ?? ""
            let soloNums = t.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            // Si no tiene exactamente 8 dígitos, lanzamos advertencia y NO guardamos
            if n.isEmpty || soloNums.count != 8 {
                self.mostrarAlerta(titulo: "Formato Incorrecto", msj: "Debes ingresa un nombre e ingresa exactamente 8 dígitos numéricos.")
                return
            }
            
            // Formatear como xxxx-xxxx
            let formatted = "\(soloNums.prefix(4))-\(soloNums.suffix(4))"
            
            if esEdicion {
                self.listaContactos[index] = Contacto(nombre: n, telefono: formatted)
            } else {
                self.listaContactos.append(Contacto(nombre: n, telefono: formatted))
            }
            self.guardarContactos(self.listaContactos)
            alFinalizar()
        }
        
        alert.addAction(actionSave)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        self.present(alert, animated: true)
    }

    func crearTarjetaContacto(c: Contacto) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.18, alpha: 1.0)
        v.layer.cornerRadius = 15
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let icon = UIImageView(image: UIImage(systemName: "person.crop.square.fill"))
        icon.tintColor = .systemRed
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let lbN = UILabel(); lbN.text = c.nombre; lbN.textColor = .white; lbN.font = .boldSystemFont(ofSize: 17)
        let lbT = UILabel(); lbT.text = c.telefono; lbT.textColor = .lightGray; lbT.font = .systemFont(ofSize: 14)
        let st = UIStackView(arrangedSubviews: [lbN, lbT]); st.axis = .vertical; st.spacing = 2; st.translatesAutoresizingMaskIntoConstraints = false
        
        let btnCall = UIButton(type: .system)
        btnCall.backgroundColor = .systemGreen
        btnCall.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        btnCall.tintColor = .white
        btnCall.layer.cornerRadius = 20
        btnCall.translatesAutoresizingMaskIntoConstraints = false
        
        // --- LLAMADA A CONTACTO DE CONFIANZA ---
        btnCall.addAction(UIAction(handler: { _ in
            self.llamarNumero(num: c.telefono)
        }), for: .touchUpInside)
        
        v.addSubview(icon); v.addSubview(st); v.addSubview(btnCall)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 15),
            icon.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 45),
            icon.heightAnchor.constraint(equalToConstant: 45),
            st.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            st.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            btnCall.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -15),
            btnCall.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            btnCall.widthAnchor.constraint(equalToConstant: 40),
            btnCall.heightAnchor.constraint(equalToConstant: 40)
        ])
        return v
    }

    func irAUbicacion() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
       
        let vistaPanel = UIView()
        vistaPanel.backgroundColor = .white
        vistaPanel.layer.cornerRadius = 25
        vistaPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vistaPanel.layer.shadowColor = UIColor.black.cgColor
        vistaPanel.layer.shadowOpacity = 0.1
        vistaPanel.layer.shadowOffset = CGSize(width: 0, height: -3)
        vistaPanel.layer.shadowRadius = 10
        vistaPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vistaPanel)
       
        let vistaHeader = UIView()
        vistaHeader.backgroundColor = .systemRed
        vistaHeader.layer.cornerRadius = 25
        vistaHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vistaHeader.translatesAutoresizingMaskIntoConstraints = false
        vistaPanel.addSubview(vistaHeader)
       
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(btnBack)
       
        let lblTitulo = UILabel()
        lblTitulo.text = "Compartir Ubicación"
        lblTitulo.textColor = .white
        lblTitulo.font = .systemFont(ofSize: 20, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(lblTitulo)
       
        let imgUbicacion = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imgUbicacion.tintColor = .systemRed
        imgUbicacion.contentMode = .scaleAspectFit
        imgUbicacion.translatesAutoresizingMaskIntoConstraints = false
        vistaPanel.addSubview(imgUbicacion)
       
        let lblMensaje = UILabel()
        lblMensaje.text = "Para enviar tu ubicación, presiona el botón de abajo."
        lblMensaje.numberOfLines = 0
        lblMensaje.textAlignment = .center
        lblMensaje.font = .systemFont(ofSize: 16)
        lblMensaje.textColor = .gray
        lblMensaje.translatesAutoresizingMaskIntoConstraints = false
        vistaPanel.addSubview(lblMensaje)
       
        let btnEnviar = UIButton(type: .system)
        btnEnviar.setTitle("Enviar Ubicación Actual", for: .normal)
        btnEnviar.backgroundColor = .systemRed
        btnEnviar.setTitleColor(.white, for: .normal)
        btnEnviar.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btnEnviar.layer.cornerRadius = 25
        btnEnviar.translatesAutoresizingMaskIntoConstraints = false
        vistaPanel.addSubview(btnEnviar)
       
        NSLayoutConstraint.activate([
            vistaPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vistaPanel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            vistaHeader.topAnchor.constraint(equalTo: vistaPanel.topAnchor),
            vistaHeader.leadingAnchor.constraint(equalTo: vistaPanel.leadingAnchor),
            vistaHeader.trailingAnchor.constraint(equalTo: vistaPanel.trailingAnchor),
            vistaHeader.heightAnchor.constraint(equalToConstant: 80),
            btnBack.leadingAnchor.constraint(equalTo: vistaHeader.leadingAnchor, constant: 20),
            btnBack.centerYAnchor.constraint(equalTo: vistaHeader.centerYAnchor),
            lblTitulo.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor),
            lblTitulo.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 15),
            imgUbicacion.centerXAnchor.constraint(equalTo: vistaPanel.centerXAnchor),
            imgUbicacion.topAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: 30),
            imgUbicacion.widthAnchor.constraint(equalToConstant: 70),
            imgUbicacion.heightAnchor.constraint(equalToConstant: 70),
            lblMensaje.topAnchor.constraint(equalTo: imgUbicacion.bottomAnchor, constant: 20),
            lblMensaje.leadingAnchor.constraint(equalTo: vistaPanel.leadingAnchor, constant: 40),
            lblMensaje.trailingAnchor.constraint(equalTo: vistaPanel.trailingAnchor, constant: -40),
            btnEnviar.bottomAnchor.constraint(equalTo: vistaPanel.bottomAnchor, constant: -40),
            btnEnviar.centerXAnchor.constraint(equalTo: vistaPanel.centerXAnchor),
            btnEnviar.widthAnchor.constraint(equalTo: vistaPanel.widthAnchor, multiplier: 0.7),
            btnEnviar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    func irAIncidentes() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
       
        let vistaHeader = UIView()
        vistaHeader.backgroundColor = .systemRed
        vistaHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vistaHeader)
       
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(btnBack)
       
        let lblTitulo = UILabel()
        lblTitulo.text = "Registro de incidentes"
        lblTitulo.textColor = .white
        lblTitulo.font = .systemFont(ofSize: 20, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(lblTitulo)
       
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
       
        let stackCampos = UIStackView()
        stackCampos.axis = .vertical
        stackCampos.spacing = 15
        stackCampos.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackCampos)
       
        let txtTitulo = crearCampoTexto(p: "Título del incidente")
        let txtUbi = crearCampoTexto(p: "Ubicación (opcional)")
       
        let txtDesc = UITextView()
        txtDesc.text = "Descripción del incidente"
        txtDesc.textColor = .lightGray
        txtDesc.font = .systemFont(ofSize: 16)
        txtDesc.layer.borderWidth = 1
        txtDesc.layer.borderColor = UIColor.systemGray4.cgColor
        txtDesc.layer.cornerRadius = 8
        txtDesc.translatesAutoresizingMaskIntoConstraints = false
        txtDesc.heightAnchor.constraint(equalToConstant: 100).isActive = true
       
        let btnGuardar = UIButton(type: .system)
        btnGuardar.setTitle("Guardar incidente", for: .normal)
        btnGuardar.backgroundColor = .systemRed
        btnGuardar.setTitleColor(.white, for: .normal)
        btnGuardar.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btnGuardar.layer.cornerRadius = 25
        btnGuardar.translatesAutoresizingMaskIntoConstraints = false
        btnGuardar.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        stackCampos.addArrangedSubview(txtTitulo)
        stackCampos.addArrangedSubview(txtUbi)
        stackCampos.addArrangedSubview(txtDesc)
        stackCampos.addArrangedSubview(btnGuardar)
       
        let lblHistorial = UILabel()
        lblHistorial.text = "Incidentes recientes"
        lblHistorial.font = .systemFont(ofSize: 18, weight: .bold)
        lblHistorial.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lblHistorial)
       
        let cardIncidente = crearTarjetaIncidente(titulo: "Incidente", desc: "Descripción", fecha: "18/02/2026 10:15", ubi: "Santa Ana")
        scrollView.addSubview(cardIncidente)
       
        NSLayoutConstraint.activate([
            vistaHeader.topAnchor.constraint(equalTo: view.topAnchor),
            vistaHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaHeader.heightAnchor.constraint(equalToConstant: 110),
            btnBack.leadingAnchor.constraint(equalTo: vistaHeader.leadingAnchor, constant: 20),
            btnBack.bottomAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: -15),
            lblTitulo.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor),
            lblTitulo.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 15),
            scrollView.topAnchor.constraint(equalTo: vistaHeader.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackCampos.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackCampos.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackCampos.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lblHistorial.topAnchor.constraint(equalTo: stackCampos.bottomAnchor, constant: 30),
            lblHistorial.leadingAnchor.constraint(equalTo: stackCampos.leadingAnchor),
            cardIncidente.topAnchor.constraint(equalTo: lblHistorial.bottomAnchor, constant: 15),
            cardIncidente.leadingAnchor.constraint(equalTo: stackCampos.leadingAnchor),
            cardIncidente.trailingAnchor.constraint(equalTo: stackCampos.trailingAnchor),
            cardIncidente.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackCampos.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    // --- INTEGRACIÓN: ALARMA DE BOLSILLO FUNCIONAL CON tone-evacuation.mp3 ---
    func irAAlarma() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        
        let lblTitulo = UILabel()
        lblTitulo.text = "Alarma de Bolsillo"
        lblTitulo.font = .systemFont(ofSize: 28, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTitulo)
        
        let btnAlarmaCentral = UIButton(type: .custom)
        btnAlarmaCentral.setTitle("¡ALARMA!", for: .normal)
        btnAlarmaCentral.backgroundColor = .systemRed
        btnAlarmaCentral.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        btnAlarmaCentral.layer.cornerRadius = 100
        btnAlarmaCentral.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnAlarmaCentral)
        
        // Lógica del botón sonoro INDEPENDIENTE
        btnAlarmaCentral.addAction(UIAction(handler: { _ in
            self.estaAlarmaSonoraActiva.toggle()
            btnAlarmaCentral.backgroundColor = self.estaAlarmaSonoraActiva ? .orange : .systemRed
            btnAlarmaCentral.setTitle(self.estaAlarmaSonoraActiva ? "DETENER" : "¡ALARMA!", for: .normal)
            
            if self.estaAlarmaSonoraActiva {
                self.reproducirSonido(nombre: "tone-evacuation")
            } else {
                self.audioPlayer?.stop()
            }
        }), for: .touchUpInside)
        
        let btnFlash = UIButton(type: .system)
        btnFlash.setTitle("Activar Flash", for: .normal)
        btnFlash.backgroundColor = UIColor.systemBlue
        btnFlash.setTitleColor(.white, for: .normal)
        btnFlash.layer.cornerRadius = 15
        btnFlash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnFlash)
        
        // Lógica del botón visual (Flash parpadeante independiente)
        btnFlash.addAction(UIAction(handler: { _ in
            self.estaFlashActivo.toggle()
            btnFlash.setTitle(self.estaFlashActivo ? "Apagar Flash" : "Activar Flash", for: .normal)
            btnFlash.backgroundColor = self.estaFlashActivo ? .darkGray : .systemBlue
            
            if self.estaFlashActivo {
                self.flashTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in self.toggleFlash() }
            } else {
                self.flashTimer?.invalidate()
                self.flashTimer = nil
                self.setFlash(on: false)
            }
        }), for: .touchUpInside)
        
        let lblInfo = UILabel()
        lblInfo.text = "Presiona el botón para activar una alarma sonora.\nUsa el botón secundario para activar el flash\ncomo señal visual."
        lblInfo.numberOfLines = 0
        lblInfo.textAlignment = .center
        lblInfo.font = .systemFont(ofSize: 14)
        lblInfo.textColor = .gray
        lblInfo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblInfo)
        
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btnBack.tintColor = .black
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnBack)
        
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lblTitulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            lblTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAlarmaCentral.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAlarmaCentral.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnAlarmaCentral.widthAnchor.constraint(equalToConstant: 200),
            btnAlarmaCentral.heightAnchor.constraint(equalToConstant: 200),
            btnFlash.topAnchor.constraint(equalTo: btnAlarmaCentral.bottomAnchor, constant: 40),
            btnFlash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnFlash.widthAnchor.constraint(equalToConstant: 160),
            btnFlash.heightAnchor.constraint(equalToConstant: 45),
            lblInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            lblInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // Funciones auxiliares para el hardware y audio
    func reproducirSonido(nombre: String) {
        guard let url = Bundle.main.url(forResource: nombre, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch { print("Error audio") }
    }

    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = (device.torchMode == .on) ? .off : .on
        device.unlockForConfiguration()
    }
    
    func setFlash(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
    }

    func irAConfig() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        let vistaHeader = UIView()
        vistaHeader.backgroundColor = .systemRed
        vistaHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vistaHeader)
        let lblConfig = UILabel()
        lblConfig.text = "Configuración"
        lblConfig.textColor = .white
        lblConfig.font = .systemFont(ofSize: 26, weight: .bold)
        lblConfig.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(lblConfig)
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnBack)
        let stackPrincipal = UIStackView()
        stackPrincipal.axis = .vertical
        stackPrincipal.spacing = 25
        stackPrincipal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackPrincipal)
        stackPrincipal.addArrangedSubview(crearEtiquetaSeccion(texto: "General"))
        stackPrincipal.addArrangedSubview(crearFilaConfig(icono: "globe", titulo: "Idioma", subtitulo: "Español"))
        let btnLogout = UIButton(type: .system)
        btnLogout.setTitle("Cerrar sesión", for: .normal)
        btnLogout.setTitleColor(.systemRed, for: .normal)
        btnLogout.contentHorizontalAlignment = .left
        btnLogout.addTarget(self, action: #selector(accionHaciaLogin), for: .touchUpInside)
        stackPrincipal.addArrangedSubview(btnLogout)
        NSLayoutConstraint.activate([
            vistaHeader.topAnchor.constraint(equalTo: view.topAnchor),
            vistaHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaHeader.heightAnchor.constraint(equalToConstant: 130),
            lblConfig.bottomAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: -20),
            lblConfig.leadingAnchor.constraint(equalTo: vistaHeader.leadingAnchor, constant: 20),
            btnBack.centerYAnchor.constraint(equalTo: lblConfig.centerYAnchor),
            btnBack.trailingAnchor.constraint(equalTo: vistaHeader.trailingAnchor, constant: -20),
            stackPrincipal.topAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: 20),
            stackPrincipal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackPrincipal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }

    func guardarContactos(_ c: [Contacto]) {
        if let data = try? JSONEncoder().encode(c) { UserDefaults.standard.set(data, forKey: "MisContactosConfianza") }
    }
    
    func cargarContactos() -> [Contacto] {
        if let data = UserDefaults.standard.data(forKey: "MisContactosConfianza"), let decoded = try? JSONDecoder().decode([Contacto].self, from: data) { return decoded }
        return []
    }

    func cargarListaUsuarios() -> [Usuario] {
        if let data = UserDefaults.standard.data(forKey: "ListaUsuariosSIGMU"),
           let decoded = try? JSONDecoder().decode([Usuario].self, from: data) {
            return decoded
        }
        return []
    }

    func esCorreoValido(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func mostrarAlerta(titulo: String, msj: String) {
        let alert = UIAlertController(title: titulo, message: msj, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func crearCampoTexto(p: String, esSeguro: Bool = false) -> UITextField {
        let t = UITextField()
        t.placeholder = p
        t.borderStyle = .roundedRect
        t.font = .systemFont(ofSize: 16)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: 45).isActive = true
       
        if esSeguro {
            t.isSecureTextEntry = true
            let btnOjo = UIButton(type: .custom)
            btnOjo.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            btnOjo.setImage(UIImage(systemName: "eye"), for: .selected)
            btnOjo.tintColor = .lightGray
            btnOjo.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btnOjo.addAction(UIAction(handler: { _ in
                btnOjo.isSelected.toggle()
                t.isSecureTextEntry = !btnOjo.isSelected
            }), for: .touchUpInside)
            t.rightView = btnOjo
            t.rightViewMode = .always
        }
        return t
    }

    func crearCeldaGuia(icono: String, titulo: String, subtitulo: String) -> UIView {
        let vista = UIView()
        vista.backgroundColor = .white
        vista.layer.cornerRadius = 15
        vista.layer.shadowColor = UIColor.black.cgColor
        vista.layer.shadowOpacity = 0.1
        vista.layer.shadowOffset = CGSize(width: 0, height: 2)
        let imgIcono = UIImageView(image: UIImage(systemName: icono))
        imgIcono.tintColor = .systemRed
        imgIcono.contentMode = .scaleAspectFit
        imgIcono.translatesAutoresizingMaskIntoConstraints = false
        let lblTitulo = UILabel()
        lblTitulo.text = titulo
        lblTitulo.font = .systemFont(ofSize: 17, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        let lblSub = UILabel()
        lblSub.text = subtitulo
        lblSub.font = .systemFont(ofSize: 13)
        lblSub.textColor = .gray
        lblSub.numberOfLines = 2
        lblSub.translatesAutoresizingMaskIntoConstraints = false
        let flecha = UIImageView(image: UIImage(systemName: "arrow.left"))
        flecha.tintColor = .systemGray4
        flecha.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(imgIcono)
        vista.addSubview(lblTitulo)
        vista.addSubview(lblSub)
        vista.addSubview(flecha)
        NSLayoutConstraint.activate([
            imgIcono.leadingAnchor.constraint(equalTo: vista.leadingAnchor, constant: 15),
            imgIcono.centerYAnchor.constraint(equalTo: vista.centerYAnchor),
            imgIcono.widthAnchor.constraint(equalToConstant: 35),
            imgIcono.heightAnchor.constraint(equalToConstant: 35),
            lblTitulo.topAnchor.constraint(equalTo: vista.topAnchor, constant: 15),
            lblTitulo.leadingAnchor.constraint(equalTo: imgIcono.trailingAnchor, constant: 15),
            lblTitulo.trailingAnchor.constraint(equalTo: flecha.leadingAnchor, constant: -10),
            lblSub.topAnchor.constraint(equalTo: lblTitulo.bottomAnchor, constant: 4),
            lblSub.leadingAnchor.constraint(equalTo: lblTitulo.leadingAnchor),
            lblSub.trailingAnchor.constraint(equalTo: lblTitulo.trailingAnchor),
            lblSub.bottomAnchor.constraint(equalTo: vista.bottomAnchor, constant: -15),
            flecha.trailingAnchor.constraint(equalTo: vista.trailingAnchor, constant: -15),
            flecha.centerYAnchor.constraint(equalTo: vista.centerYAnchor),
            flecha.widthAnchor.constraint(equalToConstant: 18)
        ])
        return vista
    }

    func crearTarjetaIncidente(titulo: String, desc: String, fecha: String, ubi: String) -> UIView {
        let vista = UIView()
        vista.backgroundColor = .white
        vista.layer.cornerRadius = 15
        vista.layer.shadowColor = UIColor.black.cgColor
        vista.layer.shadowOpacity = 0.1
        vista.layer.shadowOffset = CGSize(width: 0, height: 2)
        vista.translatesAutoresizingMaskIntoConstraints = false
        let icono = UIImageView(image: UIImage(systemName: "list.bullet.rectangle.fill"))
        icono.tintColor = .systemRed
        icono.translatesAutoresizingMaskIntoConstraints = false
        let lblT = UILabel()
        lblT.text = titulo
        lblT.font = .systemFont(ofSize: 17, weight: .bold)
        lblT.translatesAutoresizingMaskIntoConstraints = false
        let lblD = UILabel()
        lblD.text = desc
        lblD.font = .systemFont(ofSize: 14)
        lblD.textColor = .gray
        lblD.translatesAutoresizingMaskIntoConstraints = false
        let separador = UIView()
        separador.backgroundColor = .systemGray5
        separador.translatesAutoresizingMaskIntoConstraints = false
        let lblF = UILabel()
        lblF.text = "📅 \(fecha)"
        lblF.font = .systemFont(ofSize: 13)
        lblF.textColor = .darkGray
        lblF.translatesAutoresizingMaskIntoConstraints = false
        let lblU = UILabel()
        lblU.text = "📍 Ubicación: \(ubi)"
        lblU.font = .systemFont(ofSize: 13)
        lblU.textColor = .darkGray
        lblU.translatesAutoresizingMaskIntoConstraints = false
        let btnTrash = UIButton(type: .system)
        btnTrash.setImage(UIImage(systemName: "trash"), for: .normal)
        btnTrash.tintColor = .systemRed
        btnTrash.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(icono)
        vista.addSubview(lblT)
        vista.addSubview(lblD)
        vista.addSubview(separador)
        vista.addSubview(lblF)
        vista.addSubview(lblU)
        vista.addSubview(btnTrash)
        NSLayoutConstraint.activate([
            icono.leadingAnchor.constraint(equalTo: vista.leadingAnchor, constant: 15),
            icono.topAnchor.constraint(equalTo: vista.topAnchor, constant: 15),
            icono.widthAnchor.constraint(equalToConstant: 40),
            icono.heightAnchor.constraint(equalToConstant: 40),
            lblT.leadingAnchor.constraint(equalTo: icono.trailingAnchor, constant: 12),
            lblT.topAnchor.constraint(equalTo: icono.topAnchor),
            btnTrash.trailingAnchor.constraint(equalTo: vista.trailingAnchor, constant: -15),
            btnTrash.centerYAnchor.constraint(equalTo: lblT.centerYAnchor),
            lblD.leadingAnchor.constraint(equalTo: lblT.leadingAnchor),
            lblD.topAnchor.constraint(equalTo: lblT.bottomAnchor, constant: 2),
            separador.topAnchor.constraint(equalTo: icono.bottomAnchor, constant: 15),
            separador.leadingAnchor.constraint(equalTo: vista.leadingAnchor, constant: 15),
            separador.trailingAnchor.constraint(equalTo: vista.trailingAnchor, constant: -15),
            separador.heightAnchor.constraint(equalToConstant: 1),
            lblF.topAnchor.constraint(equalTo: separador.bottomAnchor, constant: 10),
            lblF.leadingAnchor.constraint(equalTo: separador.leadingAnchor),
            lblU.topAnchor.constraint(equalTo: lblF.bottomAnchor, constant: 5),
            lblU.leadingAnchor.constraint(equalTo: lblF.leadingAnchor),
            lblU.bottomAnchor.constraint(equalTo: vista.bottomAnchor, constant: -15)
        ])
        return vista
    }

    func crearEtiquetaSeccion(texto: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = texto
        lbl.textColor = UIColor.systemPurple.withAlphaComponent(0.5)
        lbl.font = .systemFont(ofSize: 15, weight: .medium)
        return lbl
    }

    func crearFilaConfig(icono: String, titulo: String, subtitulo: String) -> UIView {
        let vista = UIView()
        let img = UIImageView(image: UIImage(systemName: icono))
        img.tintColor = .systemRed
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        let lblTitle = UILabel()
        lblTitle.text = titulo
        lblTitle.font = .systemFont(ofSize: 17)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let lblSub = UILabel()
        lblSub.text = subtitulo
        lblSub.textColor = .gray
        lblSub.font = .systemFont(ofSize: 14)
        lblSub.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(img)
        vista.addSubview(lblTitle)
        vista.addSubview(lblSub)
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: vista.leadingAnchor),
            img.topAnchor.constraint(equalTo: vista.topAnchor),
            img.widthAnchor.constraint(equalToConstant: 25),
            img.heightAnchor.constraint(equalToConstant: 25),
            lblTitle.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            lblTitle.topAnchor.constraint(equalTo: img.topAnchor),
            lblSub.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lblSub.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 2),
            lblSub.bottomAnchor.constraint(equalTo: vista.bottomAnchor)
        ])
        return vista
    }
   
    func crearBotonOpcion(icono: String, titulo: String, colorIcono: UIColor) -> UIView {
        let contenedor = UIView()
        contenedor.backgroundColor = .white
        contenedor.layer.cornerRadius = 15
        contenedor.layer.shadowColor = UIColor.black.cgColor
        contenedor.layer.shadowOpacity = 0.1
        contenedor.layer.shadowOffset = CGSize(width: 0, height: 2)
        let imgView = UIImageView(image: UIImage(systemName: icono))
        imgView.tintColor = colorIcono
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let lbl = UILabel()
        lbl.text = titulo
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(imgView)
        contenedor.addSubview(lbl)
        contenedor.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 15),
            imgView.centerYAnchor.constraint(equalTo: contenedor.centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 25),
            imgView.heightAnchor.constraint(equalToConstant: 25),
            lbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 15),
            lbl.centerYAnchor.constraint(equalTo: contenedor.centerYAnchor)
        ])
        return contenedor
    }
}
