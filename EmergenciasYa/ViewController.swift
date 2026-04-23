import UIKit

class ViewController: UIViewController {
   
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
       
        let txtPassword = UITextField()
        txtPassword.placeholder = "Contraseña"
        txtPassword.isSecureTextEntry = true
        txtPassword.borderStyle = .roundedRect
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtPassword)
       
        let btnEntrar = UIButton(type: .system)
        btnEntrar.setTitle("Iniciar sesión", for: .normal)
        btnEntrar.backgroundColor = UIColor.systemRed
        btnEntrar.setTitleColor(.white, for: .normal)
        btnEntrar.layer.cornerRadius = 12
        btnEntrar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnEntrar)
        btnEntrar.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
       
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
   
    // --- PANTALLAS ---
   
    func irARegistro() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        let lblTitulo = UILabel()
        lblTitulo.text = "Crear cuenta"
        lblTitulo.font = .systemFont(ofSize: 28, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTitulo)
       
        let stackFields = UIStackView()
        stackFields.axis = .vertical
        stackFields.spacing = 15
        stackFields.distribution = .fillEqually
        stackFields.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackFields)
       
        let placeholders = ["Nombre", "Correo", "Contraseña", "Confirmar contraseña"]
        for p in placeholders {
            let txt = UITextField()
            txt.placeholder = p
            txt.borderStyle = .roundedRect
            if p.contains("Contraseña") { txt.isSecureTextEntry = true }
            stackFields.addArrangedSubview(txt)
        }
       
        let btnRegistrar = UIButton(type: .system)
        btnRegistrar.setTitle("Registrar", for: .normal)
        btnRegistrar.backgroundColor = .systemRed
        btnRegistrar.setTitleColor(.white, for: .normal)
        btnRegistrar.layer.cornerRadius = 20
        btnRegistrar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnRegistrar)
       
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
            }
            stackOpciones.addArrangedSubview(vistaBoton)
        }
       
        NSLayoutConstraint.activate([
            btnSettings.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btnSOS.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            btnSOS.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnSOS.widthAnchor.constraint(equalToConstant: tamanoSOS),
            btnSOS.heightAnchor.constraint(equalToConstant: tamanoSOS),
            stackOpciones.topAnchor.constraint(equalTo: btnSOS.bottomAnchor, constant: 40),
            stackOpciones.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackOpciones.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            stackOpciones.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    func irAEmergNums() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        let lblTitulo = UILabel()
        lblTitulo.text = "Números de Emergencia"
        lblTitulo.font = .systemFont(ofSize: 24, weight: .bold)
        lblTitulo.textAlignment = .center
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTitulo)
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btnBack.tintColor = .black
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnBack)
        let stackPrincipal = UIStackView()
        stackPrincipal.axis = .vertical
        stackPrincipal.spacing = 15
        stackPrincipal.distribution = .fillEqually
        stackPrincipal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackPrincipal)
        let filas = [
            [("LogoPolicia", "PNC", UIColor(red: 0.82, green: 0.91, blue: 1.0, alpha: 1.0)),
             ("LogoBomberos", "Bomberos", UIColor(red: 1.0, green: 0.85, blue: 0.85, alpha: 1.0))],
            [("LogoCruzRoja", "Cruz Roja", UIColor(red: 1.0, green: 0.88, blue: 0.82, alpha: 1.0)),
             ("LogoCruzVerde", "Cruz Verde", UIColor(red: 0.85, green: 0.95, blue: 0.85, alpha: 1.0))],
            [("LogoSalvamento", "Comandos de Salvamento", UIColor(red: 1.0, green: 1.0, blue: 0.85, alpha: 1.0)),
             ("LogoProtCivil", "Protección Civil", UIColor(red: 1.0, green: 0.92, blue: 0.8, alpha: 1.0))],
            [("LogoAE", "AES", UIColor(red: 0.92, green: 0.88, blue: 1.0, alpha: 1.0)),
             ("Logo123", "Sistema de Emergencias Médicas", UIColor(red: 0.85, green: 0.95, blue: 1.0, alpha: 1.0))]
        ]
        for datosFila in filas {
            let stackH = UIStackView()
            stackH.axis = .horizontal
            stackH.spacing = 15
            stackH.distribution = .fillEqually
            for (img, txt, color) in datosFila {
                let boton = crearCajonEmergencia(imagen: img, titulo: txt, fondo: color)
                stackH.addArrangedSubview(boton)
            }
            stackPrincipal.addArrangedSubview(stackH)
        }
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lblTitulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            lblTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackPrincipal.topAnchor.constraint(equalTo: lblTitulo.bottomAnchor, constant: 30),
            stackPrincipal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackPrincipal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackPrincipal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

    func irAFirstAid() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
       
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
       
        let leftIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftIcon.tintColor = .gray
        // CORRECCIÓN: Usamos width en lugar de constant
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
       
        let guias = [
            ("flame.fill", "Quemaduras", "Acciones básicas en caso de quemaduras."),
            ("heart.fill", "RCP Básica", "Reanimación cardiopulmonar para adultos."),
            ("figure.stand", "Fracturas", "Inmovilización y cuidados ante una posible fractura."),
            ("fork.knife", "Atragantamiento (Heimlich)", "Cómo actuar ante una obstrucción de la vía aérea."),
            ("drop.fill", "Hemorragias", "Cómo detener una hemorragia externa.")
        ]
       
        for (icono, titulo, sub) in guias {
            let celda = crearCeldaGuia(icono: icono, titulo: titulo, subtitulo: sub)
            stackContenido.addArrangedSubview(celda)
        }
       
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
       
        let imgVacia = UIImageView(image: UIImage(systemName: "person.crop.circle.badge.plus"))
        imgVacia.tintColor = .systemGray3
        imgVacia.contentMode = .scaleAspectFit
        imgVacia.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgVacia)
       
        let lblMensaje = UILabel()
        lblMensaje.text = "No hay contactos de confianza"
        lblMensaje.font = .systemFont(ofSize: 18, weight: .medium)
        lblMensaje.textColor = .darkGray
        lblMensaje.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblMensaje)
       
        let lblSubMensaje = UILabel()
        lblSubMensaje.text = "Usa el botón '+' para añadir uno."
        lblSubMensaje.font = .systemFont(ofSize: 14)
        lblSubMensaje.textColor = .gray
        lblSubMensaje.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblSubMensaje)
       
        let btnAdd = UIButton(type: .custom)
        btnAdd.backgroundColor = .systemRed
        btnAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        btnAdd.tintColor = .white
        btnAdd.layer.cornerRadius = 28
        btnAdd.layer.shadowColor = UIColor.black.cgColor
        btnAdd.layer.shadowOpacity = 0.3
        btnAdd.layer.shadowOffset = CGSize(width: 0, height: 4)
        btnAdd.layer.shadowRadius = 5
        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnAdd)
       
        NSLayoutConstraint.activate([
            vistaHeader.topAnchor.constraint(equalTo: view.topAnchor),
            vistaHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaHeader.heightAnchor.constraint(equalToConstant: 110),
            btnBack.leadingAnchor.constraint(equalTo: vistaHeader.leadingAnchor, constant: 20),
            btnBack.bottomAnchor.constraint(equalTo: vistaHeader.bottomAnchor, constant: -15),
            lblTitulo.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor),
            lblTitulo.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 15),
            imgVacia.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgVacia.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imgVacia.widthAnchor.constraint(equalToConstant: 100),
            imgVacia.heightAnchor.constraint(equalToConstant: 100),
            lblMensaje.topAnchor.constraint(equalTo: imgVacia.bottomAnchor, constant: 20),
            lblMensaje.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblSubMensaje.topAnchor.constraint(equalTo: lblMensaje.bottomAnchor, constant: 8),
            lblSubMensaje.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            btnAdd.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btnAdd.widthAnchor.constraint(equalToConstant: 56),
            btnAdd.heightAnchor.constraint(equalToConstant: 56)
        ])
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

    func crearCajonEmergencia(imagen: String, titulo: String, fondo: UIColor) -> UIView {
        let contenedor = UIView()
        contenedor.backgroundColor = fondo
        contenedor.layer.cornerRadius = 20
        contenedor.layer.borderWidth = 1
        contenedor.layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
        let imgView = UIImageView(image: UIImage(named: imagen))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let lbl = UILabel()
        lbl.text = titulo
        lbl.font = .systemFont(ofSize: 13, weight: .bold)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(imgView)
        contenedor.addSubview(lbl)
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: contenedor.centerXAnchor),
            imgView.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 20),
            imgView.widthAnchor.constraint(equalTo: contenedor.widthAnchor, multiplier: 0.5),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor),
            lbl.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10),
            lbl.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 10),
            lbl.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -10),
            lbl.bottomAnchor.constraint(lessThanOrEqualTo: contenedor.bottomAnchor, constant: -10)
        ])
        return contenedor
    }

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
        let btnFlash = UIButton(type: .system)
        btnFlash.setTitle("Activar Flash", for: .normal)
        btnFlash.backgroundColor = UIColor.systemBlue
        btnFlash.setTitleColor(.white, for: .normal)
        btnFlash.layer.cornerRadius = 15
        btnFlash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnFlash)
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
            btnFlash.widthAnchor.constraint(equalToConstant: 120),
            btnFlash.heightAnchor.constraint(equalToConstant: 40),
            lblInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            lblInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
   
    // --- FUNCIONES AUXILIARES ---
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
