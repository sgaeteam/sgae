/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.sgaeteam.sgae.model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Dev
 */
@Entity
@Table(name = "tipounidade", catalog = "sgaedb", schema = "")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TipoUnidade.findAll", query = "SELECT t FROM TipoUnidade t"),
    @NamedQuery(name = "TipoUnidade.findById", query = "SELECT t FROM TipoUnidade t WHERE t.id = :id"),
    @NamedQuery(name = "TipoUnidade.findByNome", query = "SELECT t FROM TipoUnidade t WHERE t.nome = :nome")})
public class TipoUnidade implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "nome")
    private String nome;

    public TipoUnidade() {
    }

    public TipoUnidade(Integer id) {
        this.id = id;
    }

    public TipoUnidade(Integer id, String nome) {
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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TipoUnidade)) {
            return false;
        }
        TipoUnidade other = (TipoUnidade) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "br.com.sgaeteam.sgae.model.TipoUnidade[ id=" + id + " ]";
    }
    
}
