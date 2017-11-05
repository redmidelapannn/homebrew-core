class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.58.0.tar.gz"
  sha256 "71830655a851e6a2bbc97ee30a803a711e57e7ebe7e58d9c166bdc849538b5b5"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f07e2be16bb53eafcac7ead1e5421993b3515b8670e33047ab837bd4bd1b2e86" => :high_sierra
    sha256 "4c1b3857eafe6161e46b0b01df61ac7d0a0d97491fe5af96d0045ad5afc7745d" => :sierra
    sha256 "0340355c2452b746aa21b5319952d3900194eeb558d8adf5edc58bd6d4781bfc" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  # Fix "compilation of ocaml-migrate-parsetree failed"
  # Reported 24 Jul 2017 https://github.com/ocaml/opam/issues/3007
  patch :DATA

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end

__END__
diff --git a/Makefile b/Makefile
index 515e581..8886bf6 100644
--- a/Makefile
+++ b/Makefile
@@ -174,8 +174,8 @@ all-homebrew:
	export OPAMYES="1"; \
	export FLOW_RELEASE="1"; \
	opam init --no-setup && \
-	opam pin add flowtype . && \
-	opam install flowtype --deps-only && \
+	opam pin add -n flowtype . && \
+	opam config exec -- opam install flowtype --deps-only && \
	opam config exec -- make

 clean:
diff --git a/Makefile b/Makefile
index 00880b4..d4d4794 100644
--- a/Makefile
+++ b/Makefile
@@ -184,11 +184,17 @@ RELEASE_TAGS=$(if $(FLOW_RELEASE),-tag warn_a,)
 all: build-flow copy-flow-files
 all-ocp: build-flow-with-ocp copy-flow-files-ocp
 
+
+OPAMROOT := $(shell mktemp -d 2> /dev/null || mktemp -d -t opam)
+
 all-homebrew:
-	export OPAMROOT="$(shell mktemp -d 2> /dev/null || mktemp -d -t opam)"; \
+	export OPAMROOT="$(OPAMROOT)"; \
 	export OPAMYES="1"; \
 	export FLOW_RELEASE="1"; \
 	opam init --no-setup && \
+	perl -p -i -e "s/\[\"\.\/configure\"/[\".\/configure\" \"-no-graph\"/" "$(OPAMROOT)/compilers/4.05.0/4.05.0/4.05.0.comp" && \
+	perl -p -i -e "s/make/make \"-j1\"/" "$(OPAMROOT)/compilers/4.05.0/4.05.0/4.05.0.comp" && \
+	opam switch 4.05.0 && \
 	opam pin add -n flowtype . && \
 	opam config exec -- opam install flowtype --deps-only && \
 	opam config exec -- make
