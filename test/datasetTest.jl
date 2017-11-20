ds = Persa.createdummydataset()

@test ds.users == 7
@test ds.items == 6
@test length(ds.preferences.possibles) == 9
@test ds.preferences.min == 1
@test ds.preferences.max == 5

for (ds_train, ds_test) in Persa.KFolds(ds, 10)
  @test ds_train.users == 7
  @test ds_train.items == 6
  @test length(ds_train.preferences.possibles) == 9
  @test ds_train.preferences.min == 1
  @test ds_train.preferences.max == 5
  @test length(ds_train) != length(ds)
  @test length(ds_train) != size(ds_test)[1]
  @test length(ds) != size(ds_test)[1]
end

holdout = Persa.HoldOut(ds, 0.9)

(ds_train, ds_test) = Persa.get(holdout)
@test ds_train.users == 7
@test ds_train.items == 6
@test length(ds_train) != length(ds)
@test length(ds_train) != size(ds_test)[1]
@test length(ds) != size(ds_test)[1]
@test Persa.sparsity(ds) >= 0

@test length(ds_train.preferences.possibles) == 9
@test ds_train.preferences.min == Base.minimum(ds_train.preferences)
@test ds_train.preferences.max == Base.maximum(ds_train.preferences)
@test eltype(ds_train.preferences) == Float64
@test size(ds_train.preferences) == 9
@test round(1.1, ds_train.preferences) == 1.0
@test round(1, ds_train.preferences) == 1.0
@test Persa.recommendation(ds_train) == 4.0
@test Persa.recommendation(ds_train.preferences) == 4.0
@test Persa.recommendation(ds_train.preferences) == Persa.recommendation(ds_train)

(u, v, r) = ds_train[1]

@test typeof(u) == Int
@test typeof(v) == Int
@test typeof(r) == Float64

@test Persa.mean(ds) >= 0
