/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.sgaeteam.sgae.model;

import java.io.Serializable;
import java.util.Collection;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Dev
 */
@Entity
@Table(name = "contato")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Contato.findAll", query = "SELECT c FROM Contato c"),
    @NamedQuery(name = "Contato.findById", query = "SELECT c FROM Contato c WHERE c.id = :id"),
    @NamedQuery(name = "Contato.findByTelCelular", query = "SELECT c FROM Contato c WHERE c.telCelular = :telCelular"),
    @NamedQuery(name = "Contato.findByTelComercial", query = "SELECT c FROM Contato c WHERE c.telComercial = :telComercial"),
    @NamedQuery(name = "Contato.findByTelResidencial", query = "SELECT c FROM Contato c WHERE c.telResidencial = :telResidencial"),
    @NamedQuery(name = "Contato.findByTelOutro", query = "SELECT c FROM Contato c WHERE c.telOutro = :telOutro"),
    @NamedQuery(name = "Contato.findByFax", query = "SELECT c FROM Contato c WHERE c.fax = :fax"),
    @NamedQuery(name = "Contato.findByEmail", query = "SELECT c FROM Contato c WHERE c.email = :email"),
    @NamedQuery(name = "Contato.findBySite", query = "SELECT c FROM Contato c WHERE c.site = :site")})
public class Contato implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Long id;
    @Basic(optional = false)
    @Column(name = "telCelular")
    private String telCelular;
    @Column(name = "telComercial")
    private String telComercial;
    @Column(name = "telResidencial")
    private String telResidencial;
    @Column(name = "telOutro")
    private String telOutro;
    @Column(name = "fax")
    private String fax;
    @Column(name = "email")
    private String email;
    @Column(name = "site")
    private String site;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "contatoid")
    private Aluno aluno;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "contatoid")
    private Collection<Unidade> unidadeCollection;

    public Contato() {
    }

    public Contato(Long id) {
        this.id = id;
    }

    public Contato(Long id, String telCelular) {
        this.id = id;
        this.telCelular = telCelular;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTelCelular() {
        return telCelular;
    }

    public void setTelCelular(String telCelular) {
        this.telCelular = telCelular;
    }

    public String getTelComercial() {
        return telComercial;
    }

    public void setTelComercial(String telComercial) {
        this.telComercial = telComercial;
    }

    public String getTelResidencial() {
        return telResidencial;
    }

    public void setTelResidencial(String telResidencial) {
        this.telResidencial = telResidencial;
    }

    public String getTelOutro() {
        return telOutro;
    }

    public void setTelOutro(String telOutro) {
        this.telOutro = telOutro;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSite() {
        return site;
    }

    public void setSite(String site) {
        this.site = site;
    }

    @XmlTransient
    public Aluno getAluno() {
        return aluno;
    }

    public void setAlunoCollection(Aluno aluno) {
        this.aluno = aluno;
    }

    @XmlTransient
    public Collection<Unidade> getUnidadeCollection() {
        return unidadeCollection;
    }

    public void setUnidadeCollection(Collection<Unidade> unidadeCollection) {
        this.unidadeCollection = unidadeCollection;
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
        if (!(object instanceof Contato)) {
            return false;
        }
        Contato other = (Contato) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "br.com.sgaeteam.sgae.model.Contato[ id=" + id + " ]";
    }
    
}
