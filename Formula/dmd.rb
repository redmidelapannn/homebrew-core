class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "https://dlang.org/"
  revision 1

  stable do
    url "https://github.com/dlang/dmd/archive/v2.071.0.tar.gz"
    sha256 "e223bfa0ad6d3cf04afd35ef03f3507e674ceefc19ff0b0109265b86b7857500"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.071.0.tar.gz"
      sha256 "54f9aea60424fe43d950112d6beaa102048e82f78bf1362d20c98525f199f356"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.071.0.tar.gz"
      sha256 "3d3f63c2cd303546c1f4ed0169b9dd69173c9d4ded501721cd846c1a05738a69"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.071.0.tar.gz"
      sha256 "e41f444cb85ee2ca723abc950c1f875d9e0004d92208a883454ff2b8efd2c441"
    end
  end

  bottle do
    revision 1
    sha256 "eb8c59288bb67fa8298f05049853b6326ac2d6d33c9f06da20d1ae0de265c19d" => :el_capitan
    sha256 "f3e0f22839c3e7dc40bcce18cc39fb6e3d5c4b9f5906aa324c42bd5b9409e963" => :yosemite
    sha256 "f00536a516ba09507abfe2242fd0783627b416a0a81aebc7b256906194148fe6" => :mavericks
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.071.1-b2.tar.gz"
    sha256 "15a1f1b2fe75a3d1f280621ac3c5ed6a046f9ff343f993f2d753e33c098fca28"
    version "2.071.1-b2"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.071.1-b2.tar.gz"
      sha256 "ef52710217ce24ac7ee188e5d06552ba207d98d3feba9ac108af651048872dc7"
      version "2.071.1-b2"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.071.1-b2.tar.gz"
      sha256 "a8bae8e2798a60aa6659764849bab7417c0edb2e08d99dcf792cf5b4e9c61bf0"
      version "2.071.1-b2"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.071.1-b2.tar.gz"
      sha256 "043a0ee183d5ab3deca0063dd4cd279a2dfe63716a9e13f2cdac8b9c5f3b7408"
      version "2.071.1-b2"
    end
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    # VERSION file is wrong upstream, has happened before, so we just overwrite it here.
    version_file = (buildpath/"VERSION")
    rm version_file
    version_file.write version

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
