/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.sgaeteam.sgae.model;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Dev
 */
@Entity
@Table(name = "aluno")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Aluno.findAll", query = "SELECT a FROM Aluno a"),
    @NamedQuery(name = "Aluno.findById", query = "SELECT a FROM Aluno a WHERE a.id = :id"),
    @NamedQuery(name = "Aluno.findByCpf", query = "SELECT a FROM Aluno a WHERE a.cpf = :cpf"),
    @NamedQuery(name = "Aluno.findByDtInscricao", query = "SELECT a FROM Aluno a WHERE a.dtInscricao = :dtInscricao"),
    @NamedQuery(name = "Aluno.findByDtNascimento", query = "SELECT a FROM Aluno a WHERE a.dtNascimento = :dtNascimento"),
    @NamedQuery(name = "Aluno.findByMae", query = "SELECT a FROM Aluno a WHERE a.mae = :mae"),
    @NamedQuery(name = "Aluno.findByNome", query = "SELECT a FROM Aluno a WHERE a.nome = :nome"),
    @NamedQuery(name = "Aluno.findByPai", query = "SELECT a FROM Aluno a WHERE a.pai = :pai"),
    @NamedQuery(name = "Aluno.findByRgNum", query = "SELECT a FROM Aluno a WHERE a.rgNum = :rgNum"),
    @NamedQuery(name = "Aluno.findByUnidadeId", query = "SELECT a FROM Aluno a WHERE a.unidadeid.id = :UnidadeId"),
    @NamedQuery(name = "Aluno.findByUnidadeIdValido", query = "SELECT a FROM Aluno a WHERE a.unidadeid.id = :UnidadeId and a.valido = :valido"),
    @NamedQuery(name = "Aluno.findByValido", query = "SELECT a FROM Aluno a WHERE a.valido = :valido"),
    @NamedQuery(name = "Aluno.findByMatricula", query = "SELECT a FROM Aluno a WHERE a.matricula = :matricula")})
public class Aluno implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Long id;
    @Basic(optional = false)
    @Column(name = "cpf")
    private String cpf;
    @Column(name = "dtInscricao")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dtInscricao;
    @Column(name = "dtNascimento")
    @Temporal(TemporalType.DATE)
    private Date dtNascimento;
    @Column(name = "mae")
    private String mae;
    @Basic(optional = false)
    @Column(name = "nome")
    private String nome;
    @Column(name = "pai")
    private String pai;
    @Column(name = "rgNum")
    private String rgNum;
    @Basic(optional = false)
    @Column(name = "valido")
    private String valido;
    @Basic(optional = false)
    @Column(name = "matricula")
    private String matricula;
    @JoinColumn(name = "Contato_id", referencedColumnName = "id")
    @OneToOne(optional = false)
    private Contato contatoid;
    @JoinColumn(name = "Endereco_id", referencedColumnName = "id")
    @OneToOne(optional = false)
    private Endereco enderecoid;
    @JoinColumn(name = "rgExp", referencedColumnName = "id")
    @ManyToOne
    private Estado rgExp;
    @JoinColumn(name = "rgOrg", referencedColumnName = "id")
    @ManyToOne
    private OrgaoEmissor rgOrg;
    @JoinColumn(name = "Unidade_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Unidade unidadeid;

    public Aluno() {
    }

    public Aluno(Long id) {
        this.id = id;
    }

    public Aluno(Long id, String cpf, String nome, String valido, String matricula) {
        this.id = id;
        this.cpf = cpf;
        this.nome = nome;
        this.valido = valido;
        this.matricula = matricula;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public Date getDtInscricao() {
        return dtInscricao;
    }

    public void setDtInscricao(Date dtInscricao) {
        this.dtInscricao = dtInscricao;
    }

    public Date getDtNascimento() {
        return dtNascimento;
    }

    public void setDtNascimento(Date dtNascimento) {
        this.dtNascimento = dtNascimento;
    }

    public String getMae() {
        return mae;
    }

    public void setMae(String mae) {
        this.mae = mae;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getPai() {
        return pai;
    }

    public void setPai(String pai) {
        this.pai = pai;
    }

    public String getRgNum() {
        return rgNum;
    }

    public void setRgNum(String rgNum) {
        this.rgNum = rgNum;
    }

    public String getValido() {
        return valido;
    }

    public void setValido(String valido) {
        this.valido = valido;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public Contato getContatoid() {
        return contatoid;
    }

    public void setContatoid(Contato contatoid) {
        this.contatoid = contatoid;
    }

    public Endereco getEnderecoid() {
        return enderecoid;
    }

    public void setEnderecoid(Endereco enderecoid) {
        this.enderecoid = enderecoid;
    }

    public Estado getRgExp() {
        return rgExp;
    }

    public void setRgExp(Estado rgExp) {
        this.rgExp = rgExp;
    }

    public OrgaoEmissor getRgOrg() {
        return rgOrg;
    }

    public void setRgOrg(OrgaoEmissor rgOrg) {
        this.rgOrg = rgOrg;
    }

    public Unidade getUnidadeid() {
        return unidadeid;
    }

    public void setUnidadeid(Unidade unidadeid) {
        this.unidadeid = unidadeid;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Aluno)) {
            return false;
        }
        Aluno other = (Aluno) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "br.com.sgaeteam.sgae.model.Aluno[ id=" + id + " ]";
    }
    
}
