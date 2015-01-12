/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.sgaeteam.sgae.model;

import java.io.Serializable;
import java.util.Collection;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Dev
 */
@Entity
@Table(name = "orgao_emissor")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "OrgaoEmissor.findAll", query = "SELECT o FROM OrgaoEmissor o"),
    @NamedQuery(name = "OrgaoEmissor.findById", query = "SELECT o FROM OrgaoEmissor o WHERE o.id = :id"),
    @NamedQuery(name = "OrgaoEmissor.findByDescricao", query = "SELECT o FROM OrgaoEmissor o WHERE o.descricao = :descricao"),
    @NamedQuery(name = "OrgaoEmissor.findBySigla", query = "SELECT o FROM OrgaoEmissor o WHERE o.sigla = :sigla")})
public class OrgaoEmissor implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "descricao")
    private String descricao;
    @Basic(optional = false)
    @Column(name = "sigla")
    private String sigla;
    @OneToMany(mappedBy = "rgOrg")
    private Collection<Aluno> alunoCollection;

    public OrgaoEmissor() {
    }

    public OrgaoEmissor(Integer id) {
        this.id = id;
    }

    public OrgaoEmissor(Integer id, String descricao, String sigla) {
        this.id = id;
        this.descricao = descricao;
        this.sigla = sigla;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getSigla() {
        return sigla;
    }

    public void setSigla(String sigla) {
        this.sigla = sigla;
    }

    @XmlTransient
    public Collection<Aluno> getAlunoCollection() {
        return alunoCollection;
    }

    public void setAlunoCollection(Collection<Aluno> alunoCollection) {
        this.alunoCollection = alunoCollection;
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
        if (!(object instanceof OrgaoEmissor)) {
            return false;
        }
        OrgaoEmissor other = (OrgaoEmissor) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "br.com.sgaeteam.sgae.model.OrgaoEmissor[ idOrgaoEmissor=" + id + " ]";
    }
    
}
