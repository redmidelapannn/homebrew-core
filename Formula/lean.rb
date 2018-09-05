class Lean < Formula
  desc "Lean theorem prover"
  homepage "https://leanprover.github.io/"
  url "https://github.com/leanprover/lean/archive/v3.4.1.tar.gz"
  sha256 "c146385e75ae8fbd88732d4443400123288bfea885c35c213efaba78b655d320"
  head "https://github.com/leanprover/lean.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5cc170c2da907399bf72c6bb6b84258cc627fa329dbefedc147b57ad6ea0c49c" => :mojave
    sha256 "872b759b44ce76bb431e7a6774bb866a8c022df22a78e80394711e41708e333c" => :high_sierra
    sha256 "a4baff592d5f239d257e35671bd301f361c0d19151c8ac902da38c42a6433fd1" => :sierra
    sha256 "62dfc2361842e8dfdf2ceb2f7af4dc9972543bd57540bd6e0cf9883c017b6ad9" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "jemalloc"

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system "#{bin}/lean", testpath/"hello.lean"
  end
end
