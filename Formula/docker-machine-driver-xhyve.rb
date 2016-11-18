class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git",
    :tag => "v0.3.0",
    :revision => "b74c23dc15666ad6d5ccdd207b87a6c44bdd584d"

  head "https://github.com/zchee/docker-machine-driver-xhyve.git"

  bottle do
    rebuild 1
    sha256 "b1cda9ed7c9ad6fb9c5b437095f39e5cd6481e87c4d86a537ef9eba55f6e3abc" => :sierra
    sha256 "83f7d82b6926a1f38b56c89de19542883aca2e8afcb7f3f4a911fcdc88ce5da0" => :el_capitan
    sha256 "bbd66d3e2a7c56d7ea6ab0e12939f46bffaf7c320215c7cc14b66edfd94987a1" => :yosemite
  end

  option "without-qcow2", "Do not support qcow2 disk image format"

  depends_on :macos => :yosemite
  depends_on "go" => :build
  depends_on "docker-machine" => :recommended
  if build.with? "qcow2"
    depends_on "opam"
    depends_on "libev" => :build
  end

  # Allow specifying version and libev location.
  patch :DATA

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    build_tags = "lib9p"

    cd build_root do
      git_hash = `git rev-parse --short HEAD --quiet`.chomp
      if build.head?
        git_hash = "HEAD-#{git_hash}"
      end

      if build.with? "qcow2"
        build_tags << " qcow2"
        ENV["LIBEV_FILE"] = "#{Formula["libev"].lib}/libev.a"

        system "opam", "init", "--no-setup"
        opam_dir = "#{buildpath}/.brew_home/.opam"

        # To imitate 'eval `opam init`'
        ENV["CAML_LD_LIBRARY_PATH"] = "#{opam_dir}/system/lib/stublibs:/usr/local/lib/ocaml/stublibs"
        ENV["OPAMUTF8MSGS"] = "1"
        ENV["PERL5LIB"] = "#{opam_dir}/system/lib/perl5"
        ENV["OCAML_TOPLEVEL_PATH"] = "#{opam_dir}/system/lib/toplevel"
        ENV.prepend_path "PATH", "#{opam_dir}/system/bin"
        system "opam", "install", "-y", "uri", "qcow-format", "conf-libev"
      end

      go_ldflags = "-w -s -X=github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew-#{git_hash}"
      ENV["GO_LDFLAGS"] = go_ldflags
      ENV["GO_BUILD_TAGS"] = build_tags
      system "make", "lib9p"
      system "make", "build", "V=1"
      bin.install "bin/docker-machine-driver-xhyve"
    end
  end

  def caveats; <<-EOS.undent
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
        sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
        sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    EOS
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end

__END__
diff --git a/Makefile b/Makefile
index d6448d0..8c26cf7 100644
--- a/Makefile
+++ b/Makefile
@@ -78,7 +78,7 @@ CGO_CFLAGS :=
 CGO_LDFLAGS :=
 
 # Parse git current branch commit-hash
-GO_LDFLAGS += -X `go list ./xhyve`.GitCommit=`git rev-parse --short HEAD 2>/dev/null`
+GO_LDFLAGS ?= -X `go list ./xhyve`.GitCommit=`git rev-parse --short HEAD 2>/dev/null`
 
 
 # Set debug gcflag, or optimize ldflags
@@ -126,8 +126,8 @@ endif
 # Use mirage-block for pwritev|preadv
 HAVE_OCAML_QCOW := $(shell if ocamlfind query qcow uri >/dev/null 2>/dev/null ; then echo YES ; else echo NO; fi)
 ifeq ($(HAVE_OCAML_QCOW),YES)
-LIBEV_FILE=/usr/local/lib/libev.a
-LIBEV=$(shell if test -e $(LIBEV_FILE) ; then echo $(LIBEV_FILE) ; fi )
+LIBEV_FILE ?= /usr/local/lib/libev.a
+LIBEV = $(shell if test -e $(LIBEV_FILE) ; then echo $(LIBEV_FILE) ; fi )
 OCAML_WHERE := $(shell ocamlc -where)
 OCAML_LDLIBS := -L $(OCAML_WHERE) \
 	$(shell ocamlfind query cstruct)/cstruct.a \
