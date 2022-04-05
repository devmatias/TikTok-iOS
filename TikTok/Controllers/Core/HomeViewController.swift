//
//  ViewController.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 31/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //Quando false não permite que a view seja manipulada fora de suas extremidades
        scrollView.bounces = false
        //Ao scrollar as views já assume a view seguinte sem ter terminado o processo de scroll
        scrollView.isPagingEnabled = true
        //Mostra a barra de scroll horizontal, nesse caso não mostra
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let control: UISegmentedControl = {
        // Fornece títulos para o segmento
        let titles = ["Following", "For You"]
        // Cria um objeto Segmented Control com os items no array determinado
        let control = UISegmentedControl(items: titles)
        // Seleciona o item do segmento inicialmente
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        //Seleciona a cor do item selecionado
        control.selectedSegmentTintColor = nil
        return control
    }()
    
    let forYouPageViewController = UIPageViewController(
        // Como a pageview vai fazer sua transição
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    // Cria objetos PostModel que só podem ser utilizados nessa viewController que possuem a função ativa mockModels que cria um array de PostModel
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()

    
    //MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setUpFeed()
        //Atribui a HomeViewController para o padrão delegate
        horizontalScrollView.delegate = self
        //Ponto cartesiano em que a view será inicializada
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeaderButtons()
    }
    
    //Atribui a horizontalScrollView os limites da view atual
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    //Cria um SegmentedControl na Navigation
    func setUpHeaderButtons() {
        //Permite a troca dos itens do SegmentControl pra uma determinada ação
        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    // Função que ao chamar a mudança do contentOffset muda o ponto de visão da view de acordo com o selecionado
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
    }
    
    private func setUpFeed() {
        // Atribui o tamanho da scrollview para se ajustar a quantidade de feeds disponiveis, no caso são 2
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
}
    func setUpFollowingFeed() {
        //Chama a primeira view do followingPosts, se tiver ele continua a função, senão ela finaliza
        guard let model = followingPosts.first else {
            return
        }
        
        //A pageViewController chama o postViewController de acordo com PostModel
        let vc = PostViewController(model: model)
        vc.delegate = self
        followingPageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil
        )
        //Atribui a viewcontroller atual ao datasource da pageviewcontroller
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        //Comando para determinar a followingPageViewController com uma relação de dependencia com a homeViewController
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    func setUpForYouFeed() {
        guard let model = forYouPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        forYouPageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil
        )
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }

}
    
    
extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Cria um objeto viewcontroller como uma PostViewcontroller com a model, senao o comando para de ser executado
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        // Cria um objeto index que recebe o primeiro post do array e ele confirma se possui o mesmo identificador do que foi trazido pela datasource
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        //Se o index for 0, não existe mais posts para tras então ele não retorna nada
        if index == 0 {
            return nil
        }
        //Se o index tiver valor ele vai diminuir uma posição no index para retornar o post anterior
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        // Se tiverem acabados todos os posts dentro do contador ele não retorna mais nada
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        // Aqui ele acrescenta valor ao index para puxar o próximo post
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    
    var currentPosts: [PostModel] {
        //Se a posição x do scroll for 0 ele puxa o followingPosts, senão puxa o foryouposts
        if horizontalScrollView.contentOffset.x == 0 {
            //Following
            return followingPosts
        }
        
        //For You
        return forYouPosts
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    // Padrão delegate que identifica se o scroll foi movimentado, se tiver sido ele identifica a posição do X para determinar com pageview deve ser selecionada
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2){
            control.selectedSegmentIndex = 0
        }
        else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    // Função do protocolo delegate que foi criado no PostViewController, pois é preciso que a HomeViewController encarregue-se das funções visuais ao interagir com o commentButton
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        //Retira a possibilidade de scroll a partir da interação com o button
        horizontalScrollView.isScrollEnabled = false
        //Retira as funcionalidades do datasource da following e foryou page quando o botão sofre interação
        if horizontalScrollView.contentOffset.x == 0 {
            //following
            followingPageViewController.dataSource = nil
        }
        else {
            forYouPageViewController.dataSource = nil
        }
        // ViewController filha assume a tela com uma determinada animação
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }

    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: CommentsViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        //Fecha os comentários ao clique do botão
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    //Depois de realizado, remove a CommentViewController como filha da HomeView Controller e retoma a view controller
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    //Retoma as funcionalidades do DataSource e de Scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPageViewController.dataSource = self
                    self?.followingPageViewController.dataSource = self
                }
            }
        }

    }
    
    
}
