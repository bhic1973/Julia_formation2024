### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 38994110-84cb-11ef-1514-d9d47e053cbb
begin
	import Pkg
	Pkg.activate(@__DIR__)
end

# ╔═╡ 03c2c9ce-3e5e-49c3-a88c-51cb46c37620
begin
	using PlutoUI, LaTeXStrings
	import FixedPointNumbers as fpn
	import Colors as col
end

# ╔═╡ 8b5f186e-91ea-4f6e-9743-860c06f19b57
begin
	using TypeTree
	print(join(tt(Any), ""))
end

# ╔═╡ ef230324-9d80-44c2-bcc5-51f340f41974
let
	using LinearAlgebra
	A = randn(Float32,10000,10000)
	b = randn(Float32,10000)
	C = similar(b)
	@time mul!(C,A,b)
end

# ╔═╡ 52ce5597-b851-421a-8739-c150c3ccdf95
TableOfContents()

# ╔═╡ 3171e74a-e29d-4c74-85a5-daabd8fce247
md"""
# Introduction à Julia 
"""

# ╔═╡ cdee333e-b9f9-471e-8a37-9a9cc16b5d17
md"""
!!! info "Pourquoi Apprendre Julia"
    Julia est un langage de programmation qui présente les caractéristiques suivantes:
	- Langage haut-niveau.
    - Dynamique;
    - Flexible;
	- Extensible;
    - Adapté au calcul scientifique, avec des performances comparables aux langages traditionnels comme le C et le Fortran;
	- Multiparadigme et multiplateforme.
"""

# ╔═╡ c2b4c228-ea7b-48ec-ac17-a07a74dfb269
md"""
!!! info "Premier programme Julia"
    Codons notre premier programme le fameux `hello-world.jl`:
	```julia
	println("hello, world!")

	```
"""

# ╔═╡ 4e709062-4342-44cf-ab76-f1b5b470f77a
subtypes(Any)

# ╔═╡ 9f48bd1d-96f6-406b-b1f8-822059bd0749
with_terminal() do
	run(`julia codes\\hello-world.jl`)
end

# ╔═╡ 70e32bcf-c8f7-4d91-9721-52e39807270b
md"## Types et structures de données"

# ╔═╡ b21b9b7d-91a9-4ca0-b5ca-bd6557522fb0
md"""
!!! info "Premier pas dans Julia: Types de données"
	Comme les autres langages de programmation, Julia dispose d'une large gamme de types de données structurés d'une manière arborescente :
"""

# ╔═╡ f164f63d-29a2-4b78-a655-2c338df2621c
md"""
## Nombres dans Julia : 
"""

# ╔═╡ a8aecb22-4194-444d-867f-2b540800218d
begin
	print(join(tt(Number), ""))
end

# ╔═╡ 8ee733d9-bfd2-4253-bd23-b812937f92cd
let
	n::UInt  = 128
	typeof(n)
end

# ╔═╡ 4797a8f3-48db-4d02-a8e1-911dc726fe59
md""" ### Entiers (Integer):
Dans la catégories des entiers, on distingue deux grandes familles:
+ Les entiers signés:  qui disposent de plusieurs sous-types selon l'ordre de grandeur qu'on veut manipuler :

||Int8|Int16|Int32|Int64|Int128|BigInt|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|bytes|1 |2|4|8|16|16|

+ Les entiers non signés:

||UInt8|UInt16|UInt32|UInt64|UInt128|
|:---:|:---:|:---:|:---:|:---:|:---:|
|bytes|1 |2|4|8|16|

```julia
@show n::BigInt = 234 |> sizeof
```
$(
with_terminal() do
	@show n = BigInt(234) |> sizeof;
end
)
Sous Julia, le typage est dynamique toutefois si vous annotez une variable d'un type donné, vous imposez implicitement à la valeur qui lui sera affecté d'avoir le même type sinon vous elevez une erreur lors de l'execution.
```julia
let
	try 
		n::Int8 = -129
	catch e
		println(e)
	end
end
```
$(
with_terminal() do
	let
		try 
			n::Int8 = -129
		catch e
			println(e)
		end
	end;
end
)

!!! info "Notez Bien"
    UInt et Int sont des aléas de UInt64 et Int64 

+ Dans la catégorie des entiers on trouve aussi les booléens:
 
$(
with_terminal() do
	@show 1 > -1
	@show 1 == -1
end
)
"""

# ╔═╡ 0ffe2863-904a-4a67-ba47-1d028ab13295
methodswith(Int)

# ╔═╡ c0ddcae4-1632-4ef6-b18d-3c1438ce8024
md"""
+ Nous avons aussi la possibilité de lister toutes les méthodes qui servent à manipuler les entiers:
$(
with_terminal() do
	for m in methodswith(Integer)
		println(m)
	end
end
)
"""

# ╔═╡ 62bb3ac3-15c2-4927-b06a-74b7ea332869
md"""
### Nombre à virgule flottante (Float) :
Ils sont tous rangé sous la catégorie de `AbstractFloat` et il sont classé selon la taille et la précision du nombre à représenter: 

||Float16|Float32|Float64|Float128|Bigfloat|
|:---:|:---:|:---:|:---:|:---:|:---:|
|bits|16 |32|64|128|256|

!!! info "Notez Bien"
    Julia dispose aussi d'un système de représentation des nombres décimaux en utilisant le concept de la virgule fixe.

"""

# ╔═╡ c57b8bfa-b62c-4b9d-8336-bc900d6f1ab2
html"""
<h3><span style="color:red;font-weight:bold;">Quel est le type de la constante π ?</span></h3>
"""

# ╔═╡ 9acf51fa-21d9-428e-975d-88025f7c71cb
let
	c = 335
	c = Int(0x0001f430)
end

# ╔═╡ 133821ff-7589-4c68-af7c-f4122ba86e82
md"""
### Conversion de type
Sous Julia il est possible réaliser la promotion des types :

$(
with_terminal() do
	@show n = UInt16(355)
	@show x::Float32 = n
	@show x = convert(Float32,n)
	@show x = Float32(n)
end
)
+ Réinterprétation :
$(
with_terminal() do
	try
		@show n = UInt32('🐇')
		@show Float32(n)
		@show reinterpret(Float32,n)
	catch e
		println(e)
	end
end
)
"""

# ╔═╡ 3361c737-cb6d-4907-9a50-51de84e04c0e
'cc'

# ╔═╡ 53983d22-cda6-4057-9d89-940a360f8b74
md"""
## Les chars et les symboles

### Caractéres :

Sous Julia, il y a une différence entre Chars et Strings. Le premier est un type primitif alors que le second est une collection composée à partir des Chars. En général, les Chars sous Julia sont codés sur 4 bytes (32 bits) :

$(
with_terminal() do
	@show c1 = 'c'
	@show c2 =  '1'
	@show c3 = 'β'
	@show c4 = '🐰'
	@show (c1,c2,c3,c4) .|> typeof
	@show (c1,c2,c3,c4) .|> sizeof
	foreach(println,methodswith(Char))
end
)
"""

# ╔═╡ dc70cb89-ba1d-4adb-9a1d-9d31deafa629
:valeur_compose |> sizeof

# ╔═╡ 892411ab-0ead-4866-8513-e964ac3ff89c
md"""
### Symboles : 
C'est un type à usage spécial sous Julia. Il est principalement utilisé comme clé pour l'indexation des dictionnaires.

$(
with_terminal() do
	@show a = :a
	@show s = Symbol("symbol")
	@show a |> typeof
	@show s |> sizeof
	foreach(println,methodswith(Symbol))
end
)
"""

# ╔═╡ 3aee0b7a-a994-431a-ba9e-d778bf69df72
md"""
## Séquences prédéfinies ou collections de données :
```julia
	# Chaine de caractere
	str::String = "Hello"
	# Listes ou tableaux
	# Tableau 1D
	arr1D::Array{Int, 1} = [1,2,3,4,5,6,7,8,9]
	# Tableau 2D
	arr2D::Array{Int, 2} = [1 2 3;4 5 6;7 8 9]
	# Tableau multidimensionnelle
	arrnD::Array{Int, 4} = Array{Int8}(undef,3,3,2,3)
	# Tuples
	t::(Int,Float64, Array{Char},Symbol) = (5, 2.79, ['a','b','c'],:names)
```
"""

# ╔═╡ 3d6a2fb1-bde7-4786-a6a3-b58b4aa9a737
md"""
### Chaines de caractères:
+ Déclaration et caractéristiques :
```julia
let
	@show str::String = "Hello, participants"
	@show str |> typeof
	@show str |> sizeof
end
```
$(
with_terminal() do
	let
		@show str::String = "Hello, participants" 
		@show str |> typeof
		@show str |> sizeof
	end
end
)
"""

# ╔═╡ 9aca1b84-6119-4e23-8130-729300523523
md"""
!!! alert "String is not an Array of Chars"

```julia
	@show str = "Julia Language version LTS"
	@show Array(str)
	@assert str != arr "String is an array"
```
$(
with_terminal() do
	@show str = "Julia Language version LTS"
	@show arr = [str...]
	@assert str != arr "String is an array"
end
)
"""

# ╔═╡ 64f9b52c-7fb6-4cd8-8adc-90bf5fff1f0b
md"""
+ Différence entre caractère et chaine de caractères

```Julia
@show str = "julia"
@show  str = 'j' * 'u' * 'l' * 'i' * 'a'
```
$(
with_terminal() do
	@show str = "julia"
	@show  str = 'j' * 'u' * 'l' * 'i' * 'a'
end
)
"""

# ╔═╡ b9453f18-d566-4df2-96a5-2ded33e061ae
md"""
+ Methodes associées aux chaines de charactères:
$(
with_terminal() do
	foreach(println,methodswith(String))
end
)
"""

# ╔═╡ 3e867714-a6fe-4298-8061-d3b7010043cb
md"""
+ String est une collection de Chars :
```julia
@show str = "Explorer le monde de Julia"
# String est un objet itérable dont les éléments sont accessibles par indexation numérique.
@assert str[9] == ' ' "Cet élément n'est pas un espace!"
@assert getindex(str,6) == 'r' "Ce n'est pas la lettre <<r>>"
@show str[6:18]
@show str[end:-1:1]
```
$(
with_terminal() do
@show str = "Explorer le monde de Julia"
# String est un objet itérable dont les éléments sont accessibles par indexation numérique.
@assert str[9] == ' ' "Cet élément n'est pas un espace!"
@assert getindex(str,6) == 'r' "Ce n'est pas la lettre <<r>>"
@show str[6:18]
@show str[end:-1:1]
end
)
"""

# ╔═╡ 6dab10a5-3add-4467-b181-86b942752d75
md"""
### Tuples
Les tuples sont des collections de données immuables qui permettent de regrouper différents types de donnés. Ils sont trés utilisés dans la déclartions et l'appel des fonctions dans Julia :

$(
with_terminal() do
	@show t1::Tuple{Int, Int, Int}=(1,2,3)
	@show t2 = (1,π,'👩')
	@show t3 = ("Julia", "julia"...,(3,2,1))
end
)
"""

# ╔═╡ c0667436-6d72-4a23-b84e-a587b12ec07d
md"""
+ Accéder et modifier les éléments d'un tuple

```julia
# Contenu non modifiable
@show t3 = ("Julia", "julia"...,(3,2,1))
@show getindex(t3[7], 2)
@show t3[1]
try
	t3[1] = "Hello"
catch 
	@error "Impossible de modifier les éléments du tuple"
finally
	@info t3[1]
end
# Contenu modifiable
@show t3 = ("Julia", "julia"...,[3,2,1])
@show getindex(t3[7], 2)	
try
	t3[7][2] = -2
catch 
	@error "Impossible de modifier les éléments du tuple"
finally
	@info t3[7]
end
```
$(
with_terminal() do
	@show t3 = ("Julia", "julia"...,(3,2,1))
	@show getindex(t3[7], 2)
	@show t3[1]
	try
		t3[1] = "Hello"
	catch 
		@error "Impossible de modifier les éléments du tuple"
	finally
		@info t3[1]
	end
	@show t3 = ("Julia", "julia"...,[3,2,1])
	@show getindex(t3[7], 2)
	try
		t3[7][2] = -2
	catch 
		@error "Impossible de modifier les éléments du tuple"
	finally
		@info t3[7]
	end
end
)

"""

# ╔═╡ 5294c813-1142-44a9-9da5-d8f0fb3b5146
md"""
+ Tuple nomé
```julia
nt = @NamedTuple{fullname::String,gendre::Symbol,age::Int}((fullname="Belkebir Hicham", gendre=:👨, age=52))
@show hasfield(typeof(nt),:fullname)
@show hasproperty(nt,:fullname)
@show propertynames(nt)
```
$(
with_terminal() do
	nt = @NamedTuple{fullname::String,gendre::Symbol,age::Int}((fullname="Belkebir Hicham", gendre=:👨, age=52))
	@show hasfield(typeof(nt),:fullname)
	@show hasproperty(nt,:fullname)
	@show propertynames(nt)
	@show getproperty(nt,:gendre)
	@show nt.gendre
end
)
"""

# ╔═╡ 92a4d6f7-7ccf-437f-bb50-e897bc0bafa3
md"""
### Arrays
Julia ne dispose pas nativement du type list. Par contre il offre un type plus général et plus performant il s'agit du type Array. C'est une collection de données indexé numériquement et pour laquelle sont définis plusieurs méthodes de manipulation qu'on va explorer globalement dans ce qui suit.

+ Array fais partie d'une catégorie de type plus globale (AbstractArray)
$(
with_terminal() do
	@show foreach(println,supertypes(Array))
end
)
+ Déclaration et annotation des Arrays
```julia
@show arr1::Array{Any,1} = Array{Any,1}()
@show arr2 = []
@show arr3 = Array{Int8,1}(undef,10,)
```
$(
with_terminal() do
	@show arr1::Array{Any,1} = Array{Any,1}()
	@show arr2 = []
	@show arr3 = Array{Int8,1}(undef,10,)
end
)
"""

# ╔═╡ 92e1a275-d8ec-41b9-a131-4469c061a36b
md"""
+ Méthodes associées avec un Array 1D (Vector)
$(
with_terminal() do
	foreach(println,methodswith(Vector))
end
)
+ Méthodes associées avec un Array 2D (Matrix)
$(
with_terminal() do
	foreach(println, methodswith(Matrix))
end
)
"""

# ╔═╡ edaf01bb-1c52-4bae-8219-ae2e4d5e195f
md"""
+ Utilisation des Arrays comme des listes
```julia
let
	@show arr::Array{Any,1} = Array{Any,1}()
	# Populate the list
	push!(arr,"Hello")
	push!(arr, ('🐰','🐺','🦁'))
	push!(arr,rand([0,1],4))
	push!(arr, :tmp)
	@show arr
	# Unpopulate the list
	while true 
		@show pop!(arr)
		length(arr) == 0 && break
	end
	@show arr
end
```
$(
with_terminal() do
	let
		@show arr::Array{Any,1} = Array{Any,1}()
		push!(arr,"Hello")
		push!(arr, ('🐰','🐺','🦁'))
		push!(arr,rand([0,1],4))
		push!(arr, :tmp)
		@show arr
		@show arr |> size
		@show arr |> length
		# Unpopulate the list
		while true 
			@show pop!(arr)
			length(arr) == 0 && break
		end
		@show arr
	end
end
)
"""

# ╔═╡ b2d43f43-0872-40d7-b957-6d7d57a9de91
md"""
+ Calcul vectoriel et matricielle sous Julia
  - *Exemple produit matrice vecteur :*
```julia
A = rand(Int,10000,10000);
b = rand(Int,10000)
@show @time A*b
```
"""

# ╔═╡ d48afc56-742d-4c50-865c-7106cf03d3c0
md"""
+ Array de compréhension :

```julia
	@time [2n^2-3n+5 for n in 0:9999 if n%3 ≠ 0]
```
$(
with_terminal() do
	@show @time (arr = [2n^2-3n+5 for n in 0:10000 if n%3 ≠ 0])
end
)

+ Remplissage avec boucle
```julia
arr = Vector{Int}()
@time let
	for n in 0:9999
		n%3 == 0 && continue
		push!(arr, 2n^2-3n+5)
	end
end
```
$(
with_terminal() do
	arr = Vector{Int}()
	@time let
		for n in 0:9999
			n%3 == 0 && continue
			push!(arr, 2n^2-3n+5)
		end
	end
end
)
"""

# ╔═╡ fa1fc6cf-65cf-4ae4-b9b0-683b9860f51e
md"""
  - Essayons maintenant le broadcasting
```julia
r = 0:9999 |> collect
@time @. 2r^2-3r+5
``` 
$(
with_terminal() do
	r = 0:9999 |> collect
	@time 2r.^2-3r .+ 5
end
)
- Calcul utilisant l'approche fonctionnel
```julia
u(n) = n^2-3n+5 
arr = [0:9999...]
@time foreach(u,arr)
@time map(u,arr)
```
$(
with_terminal() do
	u(n) = n^2-3n+5 
	arr = [0:9999...]
	@time foreach(u,filter(n->n%3==0,arr))
	@time map(u,filter(n->n%3==0,arr))
end
)
"""

# ╔═╡ 07e6cb27-e5db-4927-aaae-ecef87533dbc
md"""
+ Vecteur de vecteur est différent de Matrice :
```julia
let
	vec_of_vec = Vector{Vector{Int}}()
	for _ in 1:4
		push!(vec_of_vec, [2(n-1) for n in 1:4])
	end
	@show vec_of_vec
	@show hcat(vec_of_vec...)
end
```
$(
	with_terminal() do
		vec_of_vec = Vector{Vector{Int}}()
		for _ in 1:4
			push!(vec_of_vec, [2(n-1) for n in 1:4])
		end
		@show vec_of_vec
		@show hcat(vec_of_vec...)
		try
			@assert isa(vec_of_vec, Matrix{Int}) 
		catch
			@error "Vector of Vector is not a matrix"
		end
end
)
"""

# ╔═╡ a84c112c-9a3b-4592-80a8-584b52447eb8
md"""
## Dictionnaires et Ensembles
### Dictionaires :
À l'instar des autres langages de programmation, Julia propose dans son echosystème de type les dictionnaires et les Sets :

```julia
# Declaration using Pair
@show isa(:fullnames => String[], Pair{Symbol,Vector{String}})
d = Dict([:fullname=>String[], :gendre => Symbol[], Pair(:age, Float64[])]);
@show d
d = Dict([(:fullname,String[]),(:gendre,Symbol[]),(:age,Float64[])])
@show d
@show keys(d)
@show values(d)
```

$(
with_terminal() do
	@show isa(:fullnames => String[], Pair{Symbol,Vector{String}})
	d = Dict([:fullname=>String[], :gendre => Symbol[], :age => Float64[]]);
	@show d
	d = Dict([(:fullname,String[]),(:gendre,Symbol[]),(:age,Float64[])])
	@show d
	@show keys(d)
	@show values(d)
	@show (:fullnames => String[]) |> typeof
end
)
+ Méthodes associées aux dictionnaires :

$(
with_terminal() do
	foreach(println,methodswith(Dict))
end
)
"""

# ╔═╡ 1c5028a3-2b2a-4c3b-92ae-de5e5f74d203
md"""
### Ensembles
Les ensembles sont des types de collections de données qui interdit la redondonance.

$(
with_terminal() do
	@show S1 = Set("Hello")
	@show S2 = Set("julia!")
	@show union(S1,S2)
	@show intersect(S2,S1)
	@show setdiff(S1,S2)
	@show 'l' ∈ S1
end
)
"""

# ╔═╡ d7e7fcda-8b58-4c3b-8a14-5eddf4f5c4f2
md"""
## Fonctions
Dans Julia, une fonction est un objet qui établit une correspondance entre un tuple d'argument et un tuple de valeurs de retour.
+ Déclaration et appel des fonctions dans Julia

```julia
# Méthode classique de déclaration de fonction
function do_nothing()
	nothing
end
# Déclaration mathématicienne
do_something() = println("Hello, Julia!")

# Déclaration necessiatant plusieurs lignes
do_factorial(n) = begin
	n == 0 && return 1
	return n * do_factorial(n-1)
end
# fonction anonyme affectée à une variable
do_square = x->x^2
# Appel des fonctions
do_nothing()
do_something()
do_factorial(7)
do_factorial(do_square(4))
```
$(
with_terminal() do
	function do_nothing()
		nothing
	end
	do_something() = println("Hello, Julia!")
	do_factorial(n) = let
		n == 0 && return 1
		return n * do_factorial(n-1)
	end
	# fonction anonyme affectée à une variable
	do_square = x->x^2
	######################################
	@show do_nothing()
	@show do_something()
	@show do_factorial(20)
	@show methods(do_factorial)
	@show do_factorial((n->n^2)(4))
end
)
"""

# ╔═╡ 8423abbf-8eaf-43c9-9244-1f439735e0d5
md"""
+ Méthodes et dispatching mécanisme
```julia
add(a::Char, b::Char)::Int = Int(UInt32(a) + UInt32(b)) 
add(a::Char, b::String)::Int = begin
	sum = add(a,'\0')
	for i in eachindex(b)
		@inbounds sum += add(b[i],b[i+1])
	end
	sum
end
@show add('a', 'b')
@show add('a',"bbb")
```
$(
with_terminal() do
add(a::Char, b::Char)::Int = Int(UInt32(a) + UInt32(b)) 
	add(a::Char, b::String)::Int = begin
		sum = add(a,'\0')
		for i in eachindex(b)
			@inbounds sum += add(b[i],b[i+1])
		end
		sum
	end
	@show add('a', 'b')
	@show add('a',"bbb")
end
)
"""

# ╔═╡ 6239418a-cea1-4bf1-8a9b-3a84b03cd68c
begin
	function Base.parse(::Type{Rational},str::String)::Rational
		num, den = split(str,"//")
		parse(Int,num)//parse(Int,den)
	end
end

# ╔═╡ 710e2bba-3c19-4e12-a42e-d57887239692
md"""
+ Interprétation des Strings comme des nombres
```julia
# string -> entier
@show str = "12345"
@show n = parse(Int, str)
@show str = "12345//23"
@show n = parse(Rational,str)
```
$(
with_terminal() do
	@show str = "12345"
	@show n = parse(Int32,str)
end
)
"""

# ╔═╡ Cell order:
# ╟─38994110-84cb-11ef-1514-d9d47e053cbb
# ╟─03c2c9ce-3e5e-49c3-a88c-51cb46c37620
# ╟─52ce5597-b851-421a-8739-c150c3ccdf95
# ╟─3171e74a-e29d-4c74-85a5-daabd8fce247
# ╟─cdee333e-b9f9-471e-8a37-9a9cc16b5d17
# ╟─c2b4c228-ea7b-48ec-ac17-a07a74dfb269
# ╠═4e709062-4342-44cf-ab76-f1b5b470f77a
# ╟─9f48bd1d-96f6-406b-b1f8-822059bd0749
# ╟─70e32bcf-c8f7-4d91-9721-52e39807270b
# ╟─b21b9b7d-91a9-4ca0-b5ca-bd6557522fb0
# ╟─8b5f186e-91ea-4f6e-9743-860c06f19b57
# ╟─f164f63d-29a2-4b78-a655-2c338df2621c
# ╟─a8aecb22-4194-444d-867f-2b540800218d
# ╠═8ee733d9-bfd2-4253-bd23-b812937f92cd
# ╟─4797a8f3-48db-4d02-a8e1-911dc726fe59
# ╠═0ffe2863-904a-4a67-ba47-1d028ab13295
# ╟─c0ddcae4-1632-4ef6-b18d-3c1438ce8024
# ╟─62bb3ac3-15c2-4927-b06a-74b7ea332869
# ╟─c57b8bfa-b62c-4b9d-8336-bc900d6f1ab2
# ╠═9acf51fa-21d9-428e-975d-88025f7c71cb
# ╟─133821ff-7589-4c68-af7c-f4122ba86e82
# ╠═3361c737-cb6d-4907-9a50-51de84e04c0e
# ╟─53983d22-cda6-4057-9d89-940a360f8b74
# ╠═dc70cb89-ba1d-4adb-9a1d-9d31deafa629
# ╟─892411ab-0ead-4866-8513-e964ac3ff89c
# ╟─3aee0b7a-a994-431a-ba9e-d778bf69df72
# ╟─3d6a2fb1-bde7-4786-a6a3-b58b4aa9a737
# ╟─9aca1b84-6119-4e23-8130-729300523523
# ╟─64f9b52c-7fb6-4cd8-8adc-90bf5fff1f0b
# ╟─b9453f18-d566-4df2-96a5-2ded33e061ae
# ╟─3e867714-a6fe-4298-8061-d3b7010043cb
# ╟─710e2bba-3c19-4e12-a42e-d57887239692
# ╟─6dab10a5-3add-4467-b181-86b942752d75
# ╟─c0667436-6d72-4a23-b84e-a587b12ec07d
# ╟─5294c813-1142-44a9-9da5-d8f0fb3b5146
# ╟─92a4d6f7-7ccf-437f-bb50-e897bc0bafa3
# ╟─92e1a275-d8ec-41b9-a131-4469c061a36b
# ╟─edaf01bb-1c52-4bae-8219-ae2e4d5e195f
# ╟─b2d43f43-0872-40d7-b957-6d7d57a9de91
# ╟─ef230324-9d80-44c2-bcc5-51f340f41974
# ╟─d48afc56-742d-4c50-865c-7106cf03d3c0
# ╟─fa1fc6cf-65cf-4ae4-b9b0-683b9860f51e
# ╟─07e6cb27-e5db-4927-aaae-ecef87533dbc
# ╟─a84c112c-9a3b-4592-80a8-584b52447eb8
# ╟─1c5028a3-2b2a-4c3b-92ae-de5e5f74d203
# ╟─d7e7fcda-8b58-4c3b-8a14-5eddf4f5c4f2
# ╟─8423abbf-8eaf-43c9-9244-1f439735e0d5
# ╟─6239418a-cea1-4bf1-8a9b-3a84b03cd68c
