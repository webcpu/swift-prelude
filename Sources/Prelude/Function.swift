public func id<A>(_ a: A) -> A {
  return a
}

public func <<< <A, B, C>(_ b2c: @escaping (B) -> C, _ a2b: @escaping (A) -> B) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func >>> <A, B, C>(_ a2b: @escaping (A) -> B, _ b2c: @escaping (B) -> C) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func const<A, B>(_ a: A) -> (B) -> A {
  return { _ in a }
}

public func <| <A, B> (f: (A) -> B, a: A) -> B {
  return f(a)
}

public func |> <A, B> (a: A, f: (A) -> B) -> B {
  return f(a)
}


public func <| <A, B> (f: (A) async -> B, a: A) async -> B {
    return await f(a)
}

public func |> <A, B> (a: A, f: (A) async -> B) async -> B {
    return await f(a)
}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
  return { b in
    { a in
      f(a)(b)
    }
  }
}

// MARK: - Bind/Monad

public func flatMap <A, B, C>(_ lhs: @escaping (B) -> ((A) -> C), _ rhs: @escaping (A) -> B) -> (A) -> C {
  return { a in
    lhs(rhs(a))(a)
  }
}

public func >=> <A, B, C, D>(lhs: @escaping (A) -> ((D) -> B), rhs: @escaping (B) -> ((D) -> C))
  -> (A)
  -> ((D) -> C) {
    return { a in
      flatMap(rhs, lhs(a))
    }
}

public func >=> <Input, Success, Failure, NewSuccess>(
    _ lhs: @escaping (Input) async -> Result<Success, Failure>,
    _ rhs: @escaping (Success) async -> Result<NewSuccess, Failure>
) -> (Input) async -> Result<NewSuccess, Failure> {
    return { input in
        let firstResult = await lhs(input)
        switch firstResult {
        case .success(let value):
            return await rhs(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
