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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
@Table(name = "unidade", catalog = "sgaedb", schema = "")
@XmlRootElement
@NamedQueries({
	@NamedQuery(name = "Unidade.findByCpf", query = "SELECT und FROM Usuario usr, Unidade und, Cliente c WHERE c.id = usr.clienteid and c.id = und.clienteid AND usr.cpf = :cpf"),
    @NamedQuery(name = "Unidade.findAll", query = "SELECT u FROM Unidade u"),
    @NamedQuery(name = "Unidade.findById", query = "SELECT u FROM Unidade u WHERE u.id = :id"),
    @NamedQuery(name = "Unidade.findByNome", query = "SELECT u FROM Unidade u WHERE u.nome = :nome")})
public class Unidade implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "nome")
    private String nome;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "unidadeid")
    private Collection<Aluno> alunoCollection;
    @JoinColumn(name = "Cliente_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Cliente clienteid;
    @JoinColumn(name = "Plano_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Plano planoid;
    @JoinColumn(name = "TipoUnidade_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TipoUnidade TipoUnidadeid;
    @JoinColumn(name = "Endereco_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Endereco enderecoid;
    @JoinColumn(name = "Contato_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Contato contatoid;

    public Unidade() {
    }

    public Unidade(Integer id) {
        this.id = id;
    }

    public Unidade(Integer id, String nome) {
        this.id = id;
        this.nome = nome;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @XmlTransient
    public Collection<Aluno> getAlunoCollection() {
        return alunoCollection;
    }

    public void setAlunoCollection(Collection<Aluno> alunoCollection) {
        this.alunoCollection = alunoCollection;
    }

    public Cliente getClienteid() {
        return clienteid;
    }

    public void setClienteid(Cliente clienteid) {
        this.clienteid = clienteid;
    }

    public Plano getPlanoid() {
        return planoid;
    }

    public void setPlanoid(Plano planoid) {
        this.planoid = planoid;
    }

    public TipoUnidade getTipoUnidadeid() {
        return TipoUnidadeid;
    }

    public void setTipoUnidadeid(TipoUnidade TipoUnidadeid) {
        this.TipoUnidadeid = TipoUnidadeid;
    }

    public Endereco getEnderecoid() {
        return enderecoid;
    }

    public void setEnderecoid(Endereco enderecoid) {
        this.enderecoid = enderecoid;
    }

    public Contato getContatoid() {
        return contatoid;
    }

    public void setContatoid(Contato contatoid) {
        this.contatoid = contatoid;
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
        if (!(object instanceof Unidade)) {
            return false;
        }
        Unidade other = (Unidade) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "br.com.sgaeteam.sgae.model.Unidade[ id=" + id + " ]";
    }
    
}
