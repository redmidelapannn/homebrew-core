class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/84/1e/ff467ac56bfeaea51d4a2e72d315c1fe440b20192fea7e460f0f248acac8/numpy-1.18.2.zip"
  sha256 "e7894793e6e8540dbeac77c87b489e331947813511108ae097f1715c018b8f3d"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "851f5d4895a7dc1d28ba276e7c2b748d14ca0b28d71f93028d8f753e9e9ac0e2" => :catalina
    sha256 "d21bd59a5cbd7ec0914b2f2d1d3b77cc2ec75fecf80b370de7cc6a0e146fcd5d" => :mojave
    sha256 "9d1350bdf6844a6ed9eec7f593f1e1657dacb21a1416b227c949a7bb01de0c34" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{version}/site-packages"

    system "python3", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
