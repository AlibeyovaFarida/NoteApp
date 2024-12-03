//
//  NoteTableViewCell.swift
//  NoteApp
//
//  Created by Apple on 01.12.24.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        lb.textColor = .systemMint
        return lb
    }()
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lb.textColor = .systemGray
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(_ item: Note){
        titleLabel.text = item.title
        descriptionLabel.text = item.desc
    }
}
