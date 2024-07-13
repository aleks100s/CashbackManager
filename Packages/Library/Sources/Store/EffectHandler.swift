public protocol EffectHandler<S> {
    associatedtype S: StoreState
    func handle(effect: S.Effect) async -> S.Feedback?
}
