class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.0.tar.gz"
  sha256 "bf68861d648e3acafbd1d83a25016a0c68547b257e4fa79fb36eb5f08d665f27"
  revision 2

  bottle do
    sha256 "5f3072a35a41c64460d9e2fae0edb63e10b38b07aa3466428ae128f0e7387e2d" => :sierra
    sha256 "7dea0a3ea7dc9348211db1c68b402ade03be88a6e4d2519bcb2010fc23aa23b0" => :el_capitan
    sha256 "90fa860724af5e6f68e16aceab11b93d86ecb66a888cff9cb5890854046cec3b" => :yosemite
  end

  deprecated_option "use-openexr" => "with-openexr"

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpng"
  depends_on "boost@1.61"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "openexr" => :optional

  # Patches lseek64 => lseek
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3316200/povray/patch-lseek64.diff"
    sha256 "6ade943b074f25d35d49a82f920d81a48be7d18c9b5a6db9988020a1f9b0bda4"
  end

  # Fixes configure script's stat usage, automake subdir
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3316200/povray/patch-unix-configure.ac.diff"
    sha256 "025bfc178a6a298052ff97c0b2659b7f283d57bb0e43ba9962d3a5376ad16099"
  end

  # prebuild.sh doesn't create Makefile.in properly
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3316200/povray/patch-unix-prebuild.sh.diff"
    sha256 "1322acc324327019a31a2b97a59dbcfc6ca24981a833627399ae2ebd92c24ef6"
  end

  # missing sys/types.h header include
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3316200/povray/patch-vfe-uint.diff"
    sha256 "c8162b6574f15f4fec668e4625d33184cf949d1368c4a86297ca3592d723f1d3"
  end

  # Fixes some compiler warnings; comes from the upstream repo, should be in next release.
  patch do
    url "https://github.com/POV-Ray/povray/commit/b3846f5723745e6e7926883ec6bc404922a900e6.diff"
    sha256 "6c5c8cdf5ddf3119ed2be2133fd84eb2d76d4157644d5767eac8043aa0329a82"
  end

  # Replaces references to shared_ptr with boost::shared_ptr
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3316200/povray/boost-sharedptr.diff"
    sha256 "0db27c4bf41334fdd0b5d685defad07e62752a64f1fe5c49ae100ece5aebd358"
  end

  def install
    # include the boost system library to resolve compilation conflicts
    ENV["LIBS"] = "-lboost_system-mt -lboost_thread-mt"

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--with-openexr=#{HOMEBREW_PREFIX}" if build.with? "openexr"

    # Adjust some scripts to search for `etc` in HOMEBREW_PREFIX.
    %w[allanim allscene portfolio].each do |script|
      inreplace "unix/scripts/#{script}.sh",
                /^DEFAULT_DIR=.*$/, "DEFAULT_DIR=#{HOMEBREW_PREFIX}"
    end

    cd "unix" do
      system "./prebuild.sh"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Condensed version of `share/povray-3.7/scripts/allscene.sh` that only
    # renders variants of the famous Utah teapot as a quick smoke test.
    scenes = Dir["#{share}/povray-3.7/scenes/advanced/teapot/*.pov"]
    assert !scenes.empty?, "Failed to find test scenes."
    scenes.each do |scene|
      system "#{share}/povray-3.7/scripts/render_scene.sh", ".", scene
    end
  end
end
