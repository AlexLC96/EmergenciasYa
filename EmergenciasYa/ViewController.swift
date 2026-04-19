import UIKit

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // 1. Fondo blanco como tu mockup
        view.backgroundColor = .white
       
        // 2. CONFIGURAR LOGO (El icono rojo "E!")
        let imagenLogo = UIImageView()
        // OJO: Si todavía no subís el logo a Assets, esto saldrá vacío, pero no truena.
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
            // Logo al centro
            imagenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imagenLogo.widthAnchor.constraint(equalToConstant: 120),
            imagenLogo.heightAnchor.constraint(equalToConstant: 120),
           
            // Texto abajo del logo
            labelTitulo.topAnchor.constraint(equalTo: imagenLogo.bottomAnchor, constant: 20),
            labelTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
       
        // 5. ESPERAR 3 SEGUNDOS Y SALTAR AL LOGIN
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Queso, saltando al Login...")
           
            // Aquí llamamo el  código para abrir la pantalla de login
            self.irALogin()
        }
    }
   
    func irALogin() {
        // 1. Limpiamos todo y ponemos fondo blanco
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
       
        // 2. LOGO (El que ya subimos a Assets)
        let imagenLogo = UIImageView(image: UIImage(named: "LogoApp"))
        imagenLogo.contentMode = .scaleAspectFit
        imagenLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagenLogo)
       
        // 3. TÍTULO
        let labelTitulo = UILabel()
        labelTitulo.text = "Inicio de Sesión"
        labelTitulo.font = .systemFont(ofSize: 30, weight: .bold)
        labelTitulo.textColor = UIColor(white: 0.1, alpha: 1.0)
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTitulo)
       
        // 4. CAMPO CORREO
        let txtCorreo = UITextField()
        txtCorreo.placeholder = "Correo electrónico"
        txtCorreo.borderStyle = .roundedRect
        txtCorreo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtCorreo)
       
        // 5. CAMPO CONTRASEÑA (El que faltaba)
        let txtPassword = UITextField()
        txtPassword.placeholder = "Contraseña"
        txtPassword.isSecureTextEntry = true
        txtPassword.borderStyle = .roundedRect
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtPassword)
       
        // 6. BOTÓN ROJO
        let btnEntrar = UIButton(type: .system)
        btnEntrar.setTitle("Iniciar sesión", for: .normal)
        btnEntrar.backgroundColor = UIColor.systemRed
        btnEntrar.setTitleColor(.white, for: .normal)
        btnEntrar.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btnEntrar.layer.cornerRadius = 12
        btnEntrar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnEntrar)
       
        // LA MAGIA: Conectamos al Home (Opcion A jaja)
        btnEntrar.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
       
        // 7. TEXTO DE REGISTRO (Rojo y centrado como el mockup)
        // 7. BOTÓN DE REGISTRO (Ahora sí funciona)
        let btnHaciaRegistro = UIButton(type: .system)
        let tituloRegistro = "¿No tienes cuenta? Regístrate"
       
        // Le ponemos el estilo para que se vea igual al mockup
        btnHaciaRegistro.setTitle(tituloRegistro, for: .normal)
        btnHaciaRegistro.setTitleColor(.systemRed, for: .normal)
        btnHaciaRegistro.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        btnHaciaRegistro.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnHaciaRegistro)
       
        // LA MAGIA: Aquí le decimos qué hacer al tocarlo
        btnHaciaRegistro.addTarget(self, action: #selector(accionHaciaRegistro), for: .touchUpInside)
       
        // --- CONSTRAINTS (Alineación exacta) ---
        NSLayoutConstraint.activate([
            // Logo arriba
            imagenLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imagenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagenLogo.heightAnchor.constraint(equalToConstant: 130),
            imagenLogo.widthAnchor.constraint(equalToConstant: 130),
           
            // Título abajo del logo
            labelTitulo.topAnchor.constraint(equalTo: imagenLogo.bottomAnchor, constant: 40),
            labelTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           
            // Correo
            txtCorreo.topAnchor.constraint(equalTo: labelTitulo.bottomAnchor, constant: 50),
            txtCorreo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            txtCorreo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            txtCorreo.heightAnchor.constraint(equalToConstant: 55),
           
            // Contraseña (20pt abajo del correo)
            txtPassword.topAnchor.constraint(equalTo: txtCorreo.bottomAnchor, constant: 20),
            txtPassword.leadingAnchor.constraint(equalTo: txtCorreo.leadingAnchor),
            txtPassword.trailingAnchor.constraint(equalTo: txtCorreo.trailingAnchor),
            txtPassword.heightAnchor.constraint(equalToConstant: 55),
           
            // Botón Iniciar Sesión
            btnEntrar.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 40),
            btnEntrar.leadingAnchor.constraint(equalTo: txtCorreo.leadingAnchor),
            btnEntrar.trailingAnchor.constraint(equalTo: txtCorreo.trailingAnchor),
            btnEntrar.heightAnchor.constraint(equalToConstant: 55),
           
            // Texto de registro final
            btnHaciaRegistro.topAnchor.constraint(equalTo: btnEntrar.bottomAnchor, constant: 30),
            btnHaciaRegistro.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
   
    // --- FUNCIONES DE ACCIÓN (PUENTES) ---
   
    @objc func accionHaciaRegistro() {
        print("Cambiando a pantalla de Registro...")
        irARegistro()
    }
   
    @objc func accionHaciaLogin() {
        print("Regresando al Login...")
        irALogin()
    }
   
    @objc func accionHaciaHome() {
        print("Accediendo al Home (sin validar porque somos pros jaja)...")
        irAHome()
    }
   
    @objc func accionHaciaConfig() {
        print("Cambiando a pantalla de Configuración...")
        irAConfig()
    }
   
    // --- PANTALLAS ---
   
    func irARegistro() {
        // 1. Limpiar pantalla
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
       
        // 2. Título "Crear cuenta"
        let lblTitulo = UILabel()
        lblTitulo.text = "Crear cuenta"
        lblTitulo.font = .systemFont(ofSize: 28, weight: .bold)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTitulo)
       
        // 3. StackView (Para que los campos queden bien ordenaditos)
        let stackFields = UIStackView()
        stackFields.axis = .vertical
        stackFields.spacing = 15
        stackFields.distribution = .fillEqually
        stackFields.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackFields)
       
        // 4. Crear los 4 campos (TextFields)
        let placeholders = ["Nombre", "Correo", "Contraseña", "Confirmar contraseña"]
        for p in placeholders {
            let txt = UITextField()
            txt.placeholder = p
            txt.borderStyle = .roundedRect
            if p.contains("Contraseña") { txt.isSecureTextEntry = true }
            stackFields.addArrangedSubview(txt)
        }
       
        // 5. Botón Registrar (Rojo)
        let btnRegistrar = UIButton(type: .system)
        btnRegistrar.setTitle("Registrar", for: .normal)
        btnRegistrar.backgroundColor = .systemRed
        btnRegistrar.setTitleColor(.white, for: .normal)
        btnRegistrar.layer.cornerRadius = 20
        btnRegistrar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnRegistrar)
       
        // 6. Texto "Ya tengo una cuenta"
        let btnVolver = UIButton(type: .system)
        btnVolver.setTitle("Ya tengo una cuenta", for: .normal)
        btnVolver.setTitleColor(.black, for: .normal)
        btnVolver.titleLabel?.font = .systemFont(ofSize: 14)
        btnVolver.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnVolver)
        btnVolver.addTarget(self, action: #selector(accionHaciaLogin), for: .touchUpInside)
       
        // --- CONSTRAINTS ---
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
        // 1. Limpieza total y fondo gris muy clarito como el mockup
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
       
        // 2. BOTÓN SOS (Circular y con sombra)
        let btnSOS = UIButton(type: .custom)
        btnSOS.setTitle("SOS", for: .normal)
        btnSOS.titleLabel?.font = .systemFont(ofSize: 45, weight: .bold)
        btnSOS.backgroundColor = .systemRed
        btnSOS.setTitleColor(.white, for: .normal)
       
        // Diseño circular
        let tamanoSOS: CGFloat = 180
        btnSOS.layer.cornerRadius = tamanoSOS / 2
       
        // Sombra (Shadow) profesional para efecto de profundidad
        btnSOS.layer.shadowColor = UIColor.black.cgColor
        btnSOS.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnSOS.layer.shadowRadius = 10
        btnSOS.layer.shadowOpacity = 0.3
       
        btnSOS.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnSOS)
       
        // 3. ICONO DE AJUSTES (Tuerca arriba a la derecha)
        let btnSettings = UIButton(type: .system)
        btnSettings.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        btnSettings.tintColor = .gray
        btnSettings.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnSettings)
        btnSettings.addTarget(self, action: #selector(accionHaciaConfig), for: .touchUpInside)
       
        // 4. STACK VIEW PARA LAS OPCIONES (Botones blancos)
        let stackOpciones = UIStackView()
        stackOpciones.axis = .vertical
        stackOpciones.spacing = 12
        stackOpciones.distribution = .fillEqually
        stackOpciones.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackOpciones)
       
        // 5. LISTA DE DATOS (Icono, Título, Color)
        let datos = [
            ("phone.fill", "Números De Emergencia", UIColor.systemBlue),
            ("plus.app.fill", "Primeros Auxilios", UIColor.systemPink),
            ("person.crop.circle.fill", "Contactos de Confianza", UIColor.systemOrange),
            ("mappin.and.ellipse", "Compartir Ubicación", UIColor.systemGreen),
            ("clock.arrow.circlepath", "Registro de incidentes", UIColor.systemGray)
        ]
       
        for (icono, titulo, color) in datos {
            let vistaBoton = crearBotonOpcion(icono: icono, titulo: titulo, colorIcono: color)
            stackOpciones.addArrangedSubview(vistaBoton)
        }
       
        // --- CONSTRAINTS ---
        NSLayoutConstraint.activate([
            // Ajustes
            btnSettings.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           
            // SOS
            btnSOS.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            btnSOS.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnSOS.widthAnchor.constraint(equalToConstant: tamanoSOS),
            btnSOS.heightAnchor.constraint(equalToConstant: tamanoSOS),
           
            // Lista de opciones
            stackOpciones.topAnchor.constraint(equalTo: btnSOS.bottomAnchor, constant: 40),
            stackOpciones.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackOpciones.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            stackOpciones.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
       
        print("Queso, ya estamos en el Home con todas las opciones nítidas!")
    }

    func irAConfig() {
        // 1. Limpieza y fondo blanco
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
       
        // 2. ENCABEZADO ROJO (Como el mockup)
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
       
        // Botón Volver a Home (Tuerca o flecha blanca)
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(accionHaciaHome), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        vistaHeader.addSubview(btnBack)
       
        // 3. CONTENIDO (StackView de secciones)
        let stackPrincipal = UIStackView()
        stackPrincipal.axis = .vertical
        stackPrincipal.spacing = 25
        stackPrincipal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackPrincipal)
       
        // --- SECCIÓN GENERAL ---
        stackPrincipal.addArrangedSubview(crearEtiquetaSeccion(texto: "General"))
        stackPrincipal.addArrangedSubview(crearFilaConfig(icono: "globe", titulo: "Idioma", subtitulo: "Español"))
       
        // Botón Cerrar sesión (Rojo)
        let btnLogout = UIButton(type: .system)
        btnLogout.setTitle("Cerrar sesión", for: .normal)
        btnLogout.setTitleColor(.systemRed, for: .normal)
        btnLogout.contentHorizontalAlignment = .left
        btnLogout.titleLabel?.font = .systemFont(ofSize: 17)
        btnLogout.addTarget(self, action: #selector(accionHaciaLogin), for: .touchUpInside)
        stackPrincipal.addArrangedSubview(btnLogout)
       
        // Separador gris
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackPrincipal.addArrangedSubview(line)
       
        // --- SECCIÓN ACERCA DE ---
        stackPrincipal.addArrangedSubview(crearEtiquetaSeccion(texto: "Acerca de"))
        stackPrincipal.addArrangedSubview(crearFilaConfig(icono: "info.circle", titulo: "Versión de la app", subtitulo: "1.0.0"))
        stackPrincipal.addArrangedSubview(crearFilaConfig(icono: "doc.text", titulo: "Términos y política de privacidad", subtitulo: ""))
       
        // --- CONSTRAINTS ---
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
   
    // --- FUNCIONES AUXILIARES PARA DISEÑO ---

    func crearEtiquetaSeccion(texto: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = texto
        lbl.textColor = UIColor.systemPurple.withAlphaComponent(0.5) // Color bajito
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
       
        // Flecha a la derecha si es necesario (opcional)
        let flecha = UIImageView(image: UIImage(systemName: "chevron.right"))
        flecha.tintColor = .systemGray4
        flecha.translatesAutoresizingMaskIntoConstraints = false
       
        vista.addSubview(img)
        vista.addSubview(lblTitle)
        vista.addSubview(lblSub)
        vista.addSubview(flecha)
       
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: vista.leadingAnchor),
            img.topAnchor.constraint(equalTo: vista.topAnchor),
            img.widthAnchor.constraint(equalToConstant: 25),
            img.heightAnchor.constraint(equalToConstant: 25),
           
            lblTitle.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            lblTitle.topAnchor.constraint(equalTo: img.topAnchor),
           
            lblSub.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lblSub.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 2),
            lblSub.bottomAnchor.constraint(equalTo: vista.bottomAnchor),
           
            flecha.trailingAnchor.constraint(equalTo: vista.trailingAnchor),
            flecha.centerYAnchor.constraint(equalTo: vista.centerYAnchor),
            flecha.widthAnchor.constraint(equalToConstant: 15)
        ])
       
        return vista
    }
   
    // 🛠️ FUNCIÓN AUXILIAR PARA CREAR LOS BOTONES BLANCOS DEL HOME
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
