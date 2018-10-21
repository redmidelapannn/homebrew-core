class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.8.1.tar.gz"
  sha256 "c852fef30f511135993bc9dbed299849663d0096a72bf0797a133f86deda9e8d"
  head "https://github.com/coq/coq.git"

  bottle do
    rebuild 1
    sha256 "e4fb371bd102daa8f32599e5d61401d96641d7251a5e4438d94a81dcd60012df" => :mojave
    sha256 "95e15a8385726c3b33915542652bd64cf4ba8abe1adbce2d3200e91c28697819" => :high_sierra
    sha256 "059380b5191a468048c101666f523e4e901ba38785b512095205be76fdfe9dbb" => :sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp5"
  depends_on "ocaml"
  depends_on "ocaml-num"

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-emacslib", elisp,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.omega.Omega.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.omega.Omega.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; omega.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
