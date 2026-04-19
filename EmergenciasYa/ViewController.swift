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
    
    
    @objc func accionHaciaRegistro() {
            print("Cambiando a pantalla de Registro...")
            irARegistro()
        }
    
    
    @objc func accionHaciaLogin() {
        print("Regresando al Login...")
        irALogin()
    }
    
    
    
    
    
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
}
